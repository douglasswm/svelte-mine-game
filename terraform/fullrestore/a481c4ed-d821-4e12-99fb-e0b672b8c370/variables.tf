variable "project_name" {
  description = "Name of the project, used for resource naming"
  type        = string
  default     = "svelte-mine-game"
}

variable "environment" {
  description = "Environment name (e.g., production, staging, development)"
  type        = string
  default     = "production"
}

variable "region" {
  description = "DigitalOcean region for resources"
  type        = string
  default     = "nyc3"
}

variable "spaces_region" {
  description = "DigitalOcean Spaces region (can differ from droplet region)"
  type        = string
  default     = "nyc3"
}

variable "droplet_size" {
  description = "Droplet size slug"
  type        = string
  default     = "s-1vcpu-1gb"
}

variable "database_size" {
  description = "Database cluster size slug"
  type        = string
  default     = "db-s-1vcpu-1gb"
}

variable "ssh_public_key" {
  description = "SSH public key for droplet access"
  type        = string
  sensitive   = true
}

variable "ssh_allowed_ips" {
  description = "List of IP addresses allowed to SSH into the droplet"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "github_repo" {
  description = "GitHub repository URL"
  type        = string
  default     = "https://github.com/douglasswm/svelte-mine-game"
}

variable "github_branch" {
  description = "GitHub branch to deploy"
  type        = string
  default     = "main"
}

variable "node_version" {
  description = "Node.js version to install"
  type        = string
  default     = "20"
}

variable "app_port" {
  description = "Port the SvelteKit application listens on"
  type        = number
  default     = 3000
}

variable "origin_url" {
  description = "Origin URL for the application (used by SvelteKit adapter)"
  type        = string
  default     = ""
}
