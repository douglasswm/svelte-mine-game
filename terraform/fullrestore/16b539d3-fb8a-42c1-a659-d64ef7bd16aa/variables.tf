variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "svelte-mine-game"
}

variable "environment" {
  description = "Environment name (e.g., production, staging)"
  type        = string
  default     = "production"
}

variable "droplet_name" {
  description = "Name of the droplet"
  type        = string
  default     = "svelte-mine-game-app"
}

variable "droplet_size" {
  description = "Droplet size slug (starter tier)"
  type        = string
  default     = "s-1vcpu-1gb"
}

variable "droplet_image" {
  description = "Droplet image slug"
  type        = string
  default     = "ubuntu-22-04-x64"
}

variable "region" {
  description = "DigitalOcean region"
  type        = string
  default     = "nyc3"
}

variable "ssh_public_key" {
  description = "SSH public key for droplet access"
  type        = string
  default     = ""
  sensitive   = true
}

variable "ssh_allowed_ips" {
  description = "List of IP addresses allowed to SSH"
  type        = list(string)
  default     = ["0.0.0.0/0", "::/0"]
}

variable "node_version" {
  description = "Node.js version to install"
  type        = string
  default     = "20"
}

variable "repository_url" {
  description = "Git repository URL"
  type        = string
  default     = "https://github.com/douglasswm/svelte-mine-game"
}

variable "repository_branch" {
  description = "Git branch to deploy"
  type        = string
  default     = "main"
}

variable "build_command" {
  description = "Build command for the application"
  type        = string
  default     = "npm run build"
}

variable "app_port" {
  description = "Application port"
  type        = number
  default     = 3000
}

variable "use_reserved_ip" {
  description = "Whether to use a reserved IP address"
  type        = bool
  default     = false
}

variable "do_token" {
  description = "DigitalOcean API token"
  type        = string
  sensitive   = true
}
