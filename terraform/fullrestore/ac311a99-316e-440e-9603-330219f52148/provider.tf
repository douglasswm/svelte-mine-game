terraform {
  required_version = ">= 1.0"
  
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.78.0"
    }
  }
}

provider "digitalocean" {
  # token should be provided via DIGITALOCEAN_TOKEN environment variable
  # or through terraform.tfvars file
}
