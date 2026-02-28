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

      build_command = var.build_command
      run_command   = "node build"

      http_port = 3000

      routes {
        path = "/"
      }
    }
  }
}
