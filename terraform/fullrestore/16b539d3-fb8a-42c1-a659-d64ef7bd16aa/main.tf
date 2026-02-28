terraform {
  required_version = ">= 1.0"
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.78.0"
    }
  }
}

# Project to organize resources
resource "digitalocean_project" "svelte_mine_game" {
  name        = var.project_name
  description = "SvelteKit Minesweeper Game Application"
  purpose     = "Web Application"
  environment = var.environment
  resources   = [digitalocean_droplet.app.urn]
}

# SSH key for droplet access
resource "digitalocean_ssh_key" "default" {
  count      = var.ssh_public_key != "" ? 1 : 0
  name       = "${var.project_name}-key"
  public_key = var.ssh_public_key
}

# Droplet to host the SvelteKit application
resource "digitalocean_droplet" "app" {
  name   = var.droplet_name
  size   = var.droplet_size
  image  = var.droplet_image
  region = var.region
  
  ssh_keys = var.ssh_public_key != "" ? [digitalocean_ssh_key.default[0].id] : []
  
  tags = [
    "managed_by:fullrestore",
    "project:svelte-mine-game",
    "environment:${var.environment}",
  ]

  user_data = templatefile("${path.module}/cloud-init.yaml", {
    node_version    = var.node_version
    repo_url        = var.repository_url
    repo_branch     = var.repository_branch
    build_command   = var.build_command
    app_port        = var.app_port
  })

  monitoring = true
  ipv6       = true
  
  lifecycle {
    create_before_destroy = false
  }
}

# Firewall rules
resource "digitalocean_firewall" "app" {
  name = "${var.project_name}-firewall"

  droplet_ids = [digitalocean_droplet.app.id]

  # Allow HTTP
  inbound_rule {
    protocol         = "tcp"
    port_range       = "80"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  # Allow HTTPS
  inbound_rule {
    protocol         = "tcp"
    port_range       = "443"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  # Allow SSH
  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = var.ssh_allowed_ips
  }

  # Allow all outbound traffic
  outbound_rule {
    protocol              = "tcp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "udp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "icmp"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}

# Reserved IP for static addressing
resource "digitalocean_reserved_ip" "app" {
  count  = var.use_reserved_ip ? 1 : 0
  region = var.region
}

resource "digitalocean_reserved_ip_assignment" "app" {
  count      = var.use_reserved_ip ? 1 : 0
  ip_address = digitalocean_reserved_ip.app[0].ip_address
  droplet_id = digitalocean_droplet.app.id
}
