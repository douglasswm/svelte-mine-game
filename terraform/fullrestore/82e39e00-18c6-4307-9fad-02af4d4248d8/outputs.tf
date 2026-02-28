output "app_id" {
  description = "The ID of the DigitalOcean App"
  value       = digitalocean_app.svelte_minesweeper.id
}

output "app_url" {
  description = "The live URL of the deployed application"
  value       = digitalocean_app.svelte_minesweeper.live_url
}

output "app_default_ingress" {
  description = "The default ingress URL"
  value       = digitalocean_app.svelte_minesweeper.default_ingress
}

output "app_urn" {
  description = "The uniform resource name (URN) for the app"
  value       = digitalocean_app.svelte_minesweeper.urn
}

output "app_active_deployment_id" {
  description = "The ID of the currently active deployment"
  value       = digitalocean_app.svelte_minesweeper.active_deployment_id
}
