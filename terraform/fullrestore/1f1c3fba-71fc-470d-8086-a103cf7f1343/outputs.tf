output "app_id" {
  description = "The ID of the DigitalOcean App"
  value       = digitalocean_app.svelte_mine_game.id
}

output "app_live_url" {
  description = "The live URL of the deployed application"
  value       = digitalocean_app.svelte_mine_game.live_url
}

output "app_default_ingress" {
  description = "The default ingress URL for the app"
  value       = digitalocean_app.svelte_mine_game.default_ingress
}

output "app_urn" {
  description = "The URN of the DigitalOcean App"
  value       = digitalocean_app.svelte_mine_game.urn
}

output "app_created_at" {
  description = "Timestamp when the app was created"
  value       = digitalocean_app.svelte_mine_game.created_at
}

output "app_updated_at" {
  description = "Timestamp when the app was last updated"
  value       = digitalocean_app.svelte_mine_game.updated_at
}
