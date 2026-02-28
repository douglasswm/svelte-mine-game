variable "app_name" {
  description = "Name of the application"
  type        = string
  default     = "svelte-mine-game"
}

variable "region" {
  description = "DigitalOcean region for deployment"
  type        = string
  default     = "nyc"
  validation {
    condition     = contains(["nyc", "sfo", "ams", "sgp", "lon", "fra", "tor", "blr"], var.region)
    error_message = "Region must be a valid DigitalOcean App Platform region."
  }
}

variable "instance_size_slug" {
  description = "Size of the app instance (starter tier: basic-xxs)"
  type        = string
  default     = "basic-xxs"
}

variable "instance_count" {
  description = "Number of instances to run"
  type        = number
  default     = 1
  validation {
    condition     = var.instance_count >= 1 && var.instance_count <= 3
    error_message = "Instance count must be between 1 and 3 for starter tier."
  }
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

variable "deploy_on_push" {
  description = "Automatically deploy when pushing to the branch"
  type        = bool
  default     = true
}

variable "environment" {
  description = "Environment type for the project"
  type        = string
  default     = "Production"
  validation {
    condition     = contains(["Development", "Staging", "Production"], var.environment)
    error_message = "Environment must be Development, Staging, or Production."
  }
}
