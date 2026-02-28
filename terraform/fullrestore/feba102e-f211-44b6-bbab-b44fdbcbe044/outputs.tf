output "app_id" {
  description = "The ID of the DigitalOcean App"
  value       = digitalocean_app.svelte_mine_game.id
}

output "app_live_url" {
  description = "The live URL of the deployed application"
  value       = digitalocean_app.svelte_mine_game.live_url
}

output "app_default_ingress" {
  description = "The default ingress URL"
  value       = digitalocean_app.svelte_mine_game.default_ingress
}

output "app_urn" {
  description = "The URN of the app"
  value       = digitalocean_app.svelte_mine_game.urn
}

output "project_id" {
  description = "The ID of the DigitalOcean Project"
  value       = digitalocean_project.svelte_mine_game_project.id
}

output "created_at" {
  description = "Timestamp when the app was created"
  value       = digitalocean_app.svelte_mine_game.created_at
}

output "updated_at" {
  description = "Timestamp when the app was last updated"
  value       = digitalocean_app.svelte_mine_game.updated_at
}
