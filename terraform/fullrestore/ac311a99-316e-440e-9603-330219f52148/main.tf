resource "digitalocean_app" "svelte_mine_game" {
  spec {
    name   = var.app_name
    region = var.region

    service {
      name               = "web"
      instance_count     = 1
      instance_size_slug = var.instance_size

      github {
        repo           = var.github_repo
        branch         = var.github_branch
        deploy_on_push = true
      }

      # SvelteKit build configuration
      build_command = "pnpm install && pnpm run build"
      run_command   = "node build"

      # Environment configuration
      environment_slug = "node-js"

      env {
        key   = "NODE_VERSION"
        value = var.node_version
        scope = "BUILD_TIME"
        type  = "GENERAL"
      }

      # Health check configuration
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

      # Routes
      routes {
        path = "/"
      }
    }

    # Required tags for compliance
    alert {
      rule = "DEPLOYMENT_FAILED"
    }
  }

  # Project organization (optional but recommended)
  lifecycle {
    ignore_changes = [
      spec[0].service[0].github[0].deploy_on_push
    ]
  }
}

# Tag the app with required metadata
resource "digitalocean_project" "svelte_mine_game_project" {
  name        = "${var.app_name}-project"
  description = "SvelteKit mine game application - managed by FullRestore"
  purpose     = "Web Application"
  environment = "Production"
  resources   = [digitalocean_app.svelte_mine_game.urn]
}
