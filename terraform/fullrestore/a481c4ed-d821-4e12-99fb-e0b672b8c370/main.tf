terraform {
  required_version = ">= 1.0"
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.78.0"
    }
  }
}

# VPC for network isolation
resource "digitalocean_vpc" "main" {
  name     = "${var.project_name}-vpc"
  region   = var.region
  ip_range = "10.10.10.0/24"
}

# SSH Key for droplet access
resource "digitalocean_ssh_key" "main" {
  name       = "${var.project_name}-key"
  public_key = var.ssh_public_key
}

# Managed PostgreSQL Database Cluster
resource "digitalocean_database_cluster" "postgres" {
  name       = "${var.project_name}-db"
  engine     = "pg"
  version    = "16"
  size       = var.database_size
  region     = var.region
  node_count = 1

  private_network_uuid = digitalocean_vpc.main.id

  tags = [
    "managed_by:fullrestore",
    "project:${var.project_name}",
    "environment:${var.environment}"
  ]
}

# Database Firewall - Allow only droplet access
resource "digitalocean_database_firewall" "postgres_firewall" {
  cluster_id = digitalocean_database_cluster.postgres.id

  rule {
    type  = "droplet"
    value = digitalocean_droplet.app.id
  }
}

# Spaces Bucket for static assets
resource "digitalocean_spaces_bucket" "assets" {
  name   = "${var.project_name}-assets"
  region = var.spaces_region

  acl = "public-read"

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "HEAD"]
    allowed_origins = ["*"]
    max_age_seconds = 3600
  }

  lifecycle_rule {
    enabled = true
    prefix  = "old/"

    expiration {
      days = 90
    }
  }
}

# Application Droplet
resource "digitalocean_droplet" "app" {
  name   = "${var.project_name}-app"
  size   = var.droplet_size
  image  = "ubuntu-22-04-x64"
  region = var.region

  ssh_keys = [digitalocean_ssh_key.main.id]
  vpc_uuid = digitalocean_vpc.main.id

  tags = [
    "managed_by:fullrestore",
    "project:${var.project_name}",
    "environment:${var.environment}",
    "application:sveltekit"
  ]

  user_data = templatefile("${path.module}/cloud-init.yml", {
    github_repo        = var.github_repo
    github_branch      = var.github_branch
    database_url       = digitalocean_database_cluster.postgres.private_uri
    spaces_bucket      = digitalocean_spaces_bucket.assets.name
    spaces_endpoint    = "https://${var.spaces_region}.digitaloceanspaces.com"
    spaces_region      = var.spaces_region
    cdn_endpoint       = digitalocean_spaces_bucket.assets.bucket_domain_name
    node_version       = var.node_version
    origin_url         = var.origin_url
    port               = var.app_port
  })

  lifecycle {
    create_before_destroy = true
  }
}

# Firewall for droplet - Allow HTTP/HTTPS/SSH
resource "digitalocean_firewall" "app" {
  name = "${var.project_name}-firewall"

  droplet_ids = [digitalocean_droplet.app.id]

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = var.ssh_allowed_ips
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "80"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "443"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

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

# Project to organize resources
resource "digitalocean_project" "main" {
  name        = var.project_name
  description = "Svelte Mine Game Application"
  purpose     = "Web Application"
  environment = var.environment

  resources = [
    digitalocean_droplet.app.urn,
    digitalocean_database_cluster.postgres.urn,
    digitalocean_spaces_bucket.assets.urn
  ]
}

# Cloud-init configuration file
resource "local_file" "cloud_init" {
  filename = "${path.module}/cloud-init.yml"
  content  = <<-EOT
#cloud-config
package_update: true
package_upgrade: true

packages:
  - nginx
  - curl
  - git
  - build-essential
  - postgresql-client

write_files:
  - path: /etc/systemd/system/sveltekit.service
    content: |
      [Unit]
      Description=SvelteKit Application
      After=network.target

      [Service]
      Type=simple
      User=www-data
      WorkingDirectory=/var/www/app
      Environment="NODE_ENV=production"
      Environment="DATABASE_URL=${database_url}"
      Environment="SPACES_BUCKET=${spaces_bucket}"
      Environment="SPACES_ENDPOINT=${spaces_endpoint}"
      Environment="SPACES_REGION=${spaces_region}"
      Environment="CDN_ENDPOINT=https://${cdn_endpoint}"
      Environment="ORIGIN=${origin_url}"
      Environment="PORT=${port}"
      ExecStart=/usr/local/bin/node build/index.js
      Restart=always
      RestartSec=10

      [Install]
      WantedBy=multi-user.target

  - path: /etc/nginx/sites-available/sveltekit
    content: |
      server {
          listen 80;
          server_name _;

          location / {
              proxy_pass http://localhost:${port};
              proxy_http_version 1.1;
              proxy_set_header Upgrade $http_upgrade;
              proxy_set_header Connection 'upgrade';
              proxy_set_header Host $host;
              proxy_set_header X-Real-IP $remote_addr;
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
              proxy_set_header X-Forwarded-Proto $scheme;
              proxy_cache_bypass $http_upgrade;
          }
      }

runcmd:
  # Install Node.js ${node_version}
  - curl -fsSL https://deb.nodesource.com/setup_${node_version}.x | bash -
  - apt-get install -y nodejs
  
  # Install pnpm
  - npm install -g pnpm
  
  # Create application directory
  - mkdir -p /var/www/app
  - chown -R www-data:www-data /var/www/app
  
  # Clone and build application
  - cd /var/www/app
  - sudo -u www-data git clone --branch ${github_branch} ${github_repo} .
  - sudo -u www-data pnpm install --frozen-lockfile
  - sudo -u www-data pnpm run build
  
  # Configure nginx
  - ln -sf /etc/nginx/sites-available/sveltekit /etc/nginx/sites-enabled/
  - rm -f /etc/nginx/sites-enabled/default
  - nginx -t && systemctl restart nginx
  
  # Start application service
  - systemctl daemon-reload
  - systemctl enable sveltekit
  - systemctl start sveltekit

final_message: "SvelteKit application deployment completed!"
EOT
}
