terraform {
  required_version = ">= 1.0"
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.78.0"
    }
  }
}

# DigitalOcean App Platform for SvelteKit Application
resource "digitalocean_app" "svelte_mine_game" {
  spec {
    name   = var.app_name
    region = var.region

    # SvelteKit service configuration
    service {
      name               = "web"
      instance_count     = var.instance_count
      instance_size_slug = var.instance_size_slug

      # GitHub source configuration
      github {
        repo           = var.github_repo
        branch         = var.github_branch
        deploy_on_push = var.deploy_on_push
      }

      # Build configuration for SvelteKit
      build_command = var.build_command
      
      # SvelteKit adapter-node output
      run_command = "node build"

      # HTTP port configuration
      http_port = 3000

      # Environment variables
      dynamic "env" {
        for_each = var.environment_variables
        content {
          key   = env.key
          value = env.value
          scope = "RUN_AND_BUILD_TIME"
        }
      }

      # Health check configuration
      health_check {
        http_path             = "/"
        initial_delay_seconds = 30
        period_seconds        = 10
        timeout_seconds       = 3
        success_threshold     = 1
        failure_threshold     = 3
      }
    }

    # Required tags for compliance
    alert {
      rule = "DEPLOYMENT_FAILED"
    }
  }
}

# Project for better organization
resource "digitalocean_project" "svelte_mine_game_project" {
  name        = "${var.app_name}-project"
  description = "SvelteKit Mine Game Application - Managed by FullRestore"
  purpose     = "Web Application"
  environment = var.environment

  resources = [
    digitalocean_app.svelte_mine_game.urn
  ]
}
