output "dynamic_hostname" { # Displays dynamic hostname generated by AWS
  value       = "https://${aws_instance.pan.public_dns}"
  description = "Auto generated ephemeral DNS hostname"
}

output "static_hostname" { # Displays static hostname from Route 53
  value       = var.route53_zone_id != "" ? "https://${aws_route53_record.pan[0].fqdn}" : "No Route 53 Zone ID defined"
  description = "Route 53 DNS hostname"
}