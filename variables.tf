# Many of the below variables are required for the module to work. Please see the README for more information.

variable "panos_username" { # Default username is "admin"
  type    = string
  default = "admin"
}

variable "panos_password" { # 1 uppercase, 1 lowercase, 1 number, 1 special character, 8-16 characters
  type    = string
  default = "Password123!"
}

variable "os_version" { # MUST be valid PAN-OS version 9.1.8 or later, not all AWS regions contain all versions
  type    = string
  default = "10.2.2"
}

variable "license" { # Must select 'full' or 'partial'
  type    = string
  default = "full"

  /*
      full    = All available features
                Price: ~$1.50 per hour
                Details: https://aws.amazon.com/marketplace/pp/prodview-ihkbkomywvjq6#pdp-pricing

      partial = All features excluding Global Protect, URL filtering, and WildFire
                Price: ~$0.90 per hour 
                Details: https://aws.amazon.com/marketplace/pp/prodview-alyaxqnryhiyu#pdp-pricing
  */
}

variable "region_id" { # Select AWS Region, choose "Ohio", "West Virginia", "Oregon", or "California"
  type    = string
  default = "oregon"
}

variable "instance_type" { # EC2 instance type
  type    = string
  default = "m5.xlarge"
}

variable "route53_zone_id" { # OPTIONAL Route 53 zone ID
  type    = string
  default = ""
}

variable "route53_a_record" { # OPTIONAL Route 53 A Record
  type    = string
  default = "pan"
}


/*
  Variables below this line are not intended to be modified under normal use
*/


variable "bundle" { # Keys for specific PAYG license bundles
  type = map(string)
  default = {
    "partial" = "e9yfvyj3uag5uo5j2hjikv74n"
    "full"    = "hd44w1chf26uv4p52cdynb2o"
  }
}

variable "region" { # All US AWS regions
  type = map(any)
  default = {
    "virginia"   = "us-east-1"
    "ohio"       = "us-east-2"
    "california" = "us-west-1"
    "oregon"     = "us-west-2"
  }
}