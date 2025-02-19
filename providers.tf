terraform {
  required_providers {
    nutanix = {
      source = "nutanix/nutanix"
    }
  }
}

provider "nutanix" {
  endpoint = var.nutanix.endpoint
  username = var.nutanix.username
  password = var.nutanix.password

  # Enable this if your Nutanix endpoint has a self-signed certificate
  insecure = var.nutanix.insecure
}
