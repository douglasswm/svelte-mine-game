output "app_id" {
  description = "The ID of the deployed application"
  value       = digitalocean_app.svelte_mine_game.id
}

output "app_urn" {
  description = "The URN of the deployed application"
  value       = digitalocean_app.svelte_mine_game.urn
}

output "live_url" {
  description = "The live URL of the deployed application"
  value       = digitalocean_app.svelte_mine_game.live_url
}

output "default_ingress" {
  description = "The default ingress URL"
  value       = digitalocean_app.svelte_mine_game.default_ingress
}

output "project_id" {
  description = "The ID of the DigitalOcean project"
  value       = digitalocean_project.svelte_mine_game_project.id
}

output "app_status" {
  description = "Current status of the application"
  value       = digitalocean_app.svelte_mine_game.active_deployment[0].id
}
