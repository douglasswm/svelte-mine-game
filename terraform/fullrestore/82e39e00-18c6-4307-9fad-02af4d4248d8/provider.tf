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
  # Token should be set via DIGITALOCEAN_TOKEN environment variable
  # or passed via token = var.do_token
}
