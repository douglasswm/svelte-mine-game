/**
 * DigitalOcean App Platform Deployment for Svelte Minesweeper
 * 
 * This configuration deploys a SvelteKit static site on DigitalOcean App Platform
 * with automatic builds from GitHub repository
 */

resource "digitalocean_app" "svelte_minesweeper" {
  spec {
    name   = var.app_name
    region = var.region

    # Static site configuration for SvelteKit
    static_site {
      name             = "svelte-minesweeper-site"
      build_command    = var.build_command
      output_dir       = var.output_directory
      environment_slug = "node-js"

      # GitHub source configuration
      github {
        repo           = var.github_repo
        branch         = var.github_branch
        deploy_on_push = var.auto_deploy
      }

      # Routes configuration for SvelteKit
      routes {
        path = "/"
      }
    }
  }
}
