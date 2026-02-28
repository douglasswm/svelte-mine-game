variable "app_name" {
  description = "Name of the DigitalOcean App"
  type        = string
  default     = "svelte-mine-game"
}

variable "region" {
  description = "DigitalOcean region for deployment"
  type        = string
  default     = "nyc"
}

variable "github_repo" {
  description = "GitHub repository in format owner/repo"
  type        = string
  default     = "douglasswm/svelte-mine-game"
}

variable "github_branch" {
  description = "GitHub branch to deploy"
  type        = string
  default     = "main"
}

variable "instance_size" {
  description = "App Platform instance size (basic-xxs, basic-xs, basic-s, etc.)"
  type        = string
  default     = "basic-xxs"
}

variable "node_version" {
  description = "Node.js version to use"
  type        = string
  default     = "20"
}
