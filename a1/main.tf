# Provider declaration
terraform {
  required_providers {
    aci = {
        source = "CiscoDevNet/aci"
    }
    mso = {
        source = "CiscoDevNet/mso"
    }
  }
}

# Sigle site
# Provider configuration
provider "aci" {
    url = "https://nat.vprokopo.cisco.com:21291"
    username = "terraformuser"
    private_key = "terraformuser.key"
    cert_name = "terraformuser_cert"
}

resource "aci_tenant" "vanilla" {
  name = "vanilla"
}

# Multiple sites (Multi-Site)
provider "mso" {
  url = "https://nat.vprokopo.cisco.com:21341"
  username = "tacacsuser"
  password = "tacacs123!"
  domain = "TACACS"
}

resource "mso_tenant" "vanilla" {
  name = "vanilla"
  display_name = "vanilla"
}

