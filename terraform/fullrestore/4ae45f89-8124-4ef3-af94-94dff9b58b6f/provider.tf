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
  # Authentication via DIGITALOCEAN_TOKEN environment variable
  # Export the token before running Terraform:
  # export DIGITALOCEAN_TOKEN="your_token_here"
}
