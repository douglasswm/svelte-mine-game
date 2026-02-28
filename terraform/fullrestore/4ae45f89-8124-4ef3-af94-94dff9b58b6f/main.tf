terraform {
  required_version = ">= 1.0"
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.78.0"
    }
  }
}

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

      # SvelteKit-specific build configuration
      build_command = var.build_command
      run_command   = var.run_command

      # Use detected output directory
      source_dir = "/"

      http_port = 3000

      # Health check configuration
      health_check {
        http_path             = "/"
        initial_delay_seconds = 30
        period_seconds        = 10
        timeout_seconds       = 5
        success_threshold     = 1
        failure_threshold     = 3
      }

      # Environment variables for Node.js
      env {
        key   = "NODE_VERSION"
        value = var.node_version
        scope = "BUILD_TIME"
      }

      env {
        key   = "NODE_ENV"
        value = "production"
        scope = "RUN_TIME"
      }
    }

    # Add required tags for security policy compliance
    features = []
  }
}
