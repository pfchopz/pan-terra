resource "tls_private_key" "pk" { # Generate SSH key
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "kp" { # Create EC2 key pair with generated SSH key
  public_key = tls_private_key.pk.public_key_openssh
}

resource "local_file" "sshPrivateKey" { # Create local file with generated SSH key
  content  = tls_private_key.pk.private_key_pem
  filename = "${path.module}/sshPrivateKey.pem"
}

data "aws_ami_ids" "pan" { # Find AMI for selected PAN-OS version and license bundle
  owners = ["679593333241"]

  filter {
    name   = "product-code"
    values = [var.bundle[var.license]]
  }

  filter {
    name   = "name"
    values = ["PA-VM-AWS*${var.os_version}*"]
  }
}

resource "aws_instance" "pan" { # Create EC2 instance of Palo Alto Firewall
  ami           = data.aws_ami_ids.pan.ids[0]
  instance_type = var.instance_type
  key_name      = aws_key_pair.kp.key_name

  tags = {
    Name = "Palo Alto"
  }

  provisioner "local-exec" { # Checks for Palo Alto web interface readiness
    command = "./scripts/curl_probe.sh ${aws_instance.pan.public_dns}"
  }

  provisioner "local-exec" { # Creates admin user on Palo Alto
    command = "./scripts/create_user.sh ${path.module}/sshPrivateKey.pem"

    environment = {
      PANOS_HOSTNAME = aws_instance.pan.public_dns
      PANOS_USERNAME = var.panos_username
      PANOS_PASSWORD = var.panos_password
    }
  }
}

resource "aws_route53_record" "pan" { # Update Route 53 DNS if applicable
  count = var.route53_zone_id != "" ? 1 : 0

  zone_id = var.route53_zone_id
  name    = var.route53_a_record
  type    = "A"
  ttl     = 300
  records = [aws_instance.pan.public_ip]
}

resource "null_resource" "pan_backup" { # Backups up Palo Alto configuration on destroy
  depends_on = [aws_instance.pan]

  triggers = {
    username = var.panos_username
    password = var.panos_password
    hostname = aws_instance.pan.public_dns
  }

  provisioner "local-exec" { # Executes backup script
    when    = destroy
    command = "./scripts/backup_config.sh '${self.triggers.username}' '${self.triggers.password}' '${self.triggers.hostname}'"
  }
}

resource "null_resource" "pan_restore" { # Backups up Palo Alto configuration on destroy
  depends_on = [aws_instance.pan]

  triggers = {
    username = var.panos_username
    password = var.panos_password
    hostname = aws_instance.pan.public_dns
  }

  provisioner "local-exec" { # Executes restore script
    command = "./scripts/restore_config.sh '${self.triggers.username}' '${self.triggers.password}' '${self.triggers.hostname}'"
  }
}