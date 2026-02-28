output "app_id" {
  description = "The ID of the DigitalOcean App"
  value       = digitalocean_app.svelte_mine_game.id
}

output "app_url" {
  description = "The live URL of the deployed application"
  value       = digitalocean_app.svelte_mine_game.live_url
}

output "app_urn" {
  description = "The URN of the app"
  value       = digitalocean_app.svelte_mine_game.urn
}

output "default_ingress" {
  description = "The default ingress URL for the app"
  value       = digitalocean_app.svelte_mine_game.default_ingress
}

output "app_created_at" {
  description = "The date and time when the app was created"
  value       = digitalocean_app.svelte_mine_game.created_at
}
