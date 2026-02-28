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
  description = "The URN of the app for project resource assignment"
  value       = digitalocean_app.svelte_mine_game.urn
}

output "project_id" {
  description = "The ID of the project containing the app"
  value       = digitalocean_project.svelte_mine_game_project.id
}
