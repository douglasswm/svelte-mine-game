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
  # Token should be set via environment variable: DIGITALOCEAN_TOKEN
  # or using terraform.tfvars
}
