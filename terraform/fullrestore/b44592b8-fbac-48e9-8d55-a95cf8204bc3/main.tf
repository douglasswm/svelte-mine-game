terraform {
  required_version = ">= 1.0"
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.78.0"
    }
  }
}

# DigitalOcean App Platform deployment for SvelteKit application
resource "digitalocean_app" "svelte_mine_game" {
  spec {
    name   = var.app_name
    region = var.region

    service {
      name               = "web"
      instance_count     = var.instance_count
      instance_size_slug = var.instance_size_slug

      github {
        repo           = var.github_repo
        branch         = var.github_branch
        deploy_on_push = var.deploy_on_push
      }

      # SvelteKit build configuration
      build_command = "pnpm install && pnpm run build"
      run_command   = "node build"

      # Health check for the application
      health_check {
        http_path             = "/"
        initial_delay_seconds = 30
        period_seconds        = 10
        timeout_seconds       = 5
        success_threshold     = 1
        failure_threshold     = 3
      }

      # HTTP port configuration
      http_port = 3000

      # Environment variables for Node.js
      env {
        key   = "NODE_ENV"
        value = "production"
        scope = "RUN_TIME"
      }

      env {
        key   = "PORT"
        value = "3000"
        scope = "RUN_TIME"
      }
    }
  }
}

# Project resource to organize the app
resource "digitalocean_project" "svelte_mine_game_project" {
  name        = "${var.app_name}-project"
  description = "SvelteKit Mine Game Application"
  purpose     = "Web Application"
  environment = var.environment

  resources = [
    digitalocean_app.svelte_mine_game.urn
  ]
}
