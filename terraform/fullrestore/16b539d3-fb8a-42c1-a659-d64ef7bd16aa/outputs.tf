output "droplet_id" {
  description = "The ID of the droplet"
  value       = digitalocean_droplet.app.id
}

output "droplet_name" {
  description = "The name of the droplet"
  value       = digitalocean_droplet.app.name
}

output "droplet_public_ipv4" {
  description = "The public IPv4 address of the droplet"
  value       = digitalocean_droplet.app.ipv4_address
}

output "droplet_public_ipv6" {
  description = "The public IPv6 address of the droplet"
  value       = digitalocean_droplet.app.ipv6_address
}

output "droplet_urn" {
  description = "The URN of the droplet"
  value       = digitalocean_droplet.app.urn
}

output "reserved_ip" {
  description = "Reserved IP address (if enabled)"
  value       = var.use_reserved_ip ? digitalocean_reserved_ip.app[0].ip_address : null
}

output "application_url" {
  description = "URL to access the application"
  value       = var.use_reserved_ip ? "http://${digitalocean_reserved_ip.app[0].ip_address}" : "http://${digitalocean_droplet.app.ipv4_address}"
}

output "project_id" {
  description = "The ID of the DigitalOcean project"
  value       = digitalocean_project.svelte_mine_game.id
}

output "ssh_connection" {
  description = "SSH connection string"
  value       = "ssh root@${digitalocean_droplet.app.ipv4_address}"
}
