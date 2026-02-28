variable "app_name" {
  description = "Name of the DigitalOcean App"
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

variable "instance_count" {
  description = "Number of instances to run"
  type        = number
  default     = 1
  
  validation {
    condition     = var.instance_count >= 1 && var.instance_count <= 10
    error_message = "Instance count must be between 1 and 10."
  }
}

variable "instance_size_slug" {
  description = "Size of the app instance (starter tier: basic-xxs)"
  type        = string
  default     = "basic-xxs"
}

variable "github_repo" {
  description = "GitHub repository in format: owner/repo"
  type        = string
  default     = "douglasswm/svelte-mine-game"
}

variable "github_branch" {
  description = "GitHub branch to deploy"
  type        = string
  default     = "main"
}

variable "deploy_on_push" {
  description = "Enable automatic deployment on git push"
  type        = bool
  default     = true
}

variable "build_command" {
  description = "Build command for the application"
  type        = string
  default     = "npm run build"
}

variable "environment" {
  description = "Environment type (Development, Staging, Production)"
  type        = string
  default     = "Production"
  
  validation {
    condition     = contains(["Development", "Staging", "Production"], var.environment)
    error_message = "Environment must be Development, Staging, or Production."
  }
}

variable "environment_variables" {
  description = "Environment variables for the application"
  type        = map(string)
  default     = {
    NODE_VERSION = "20"
    # Add any additional environment variables here
  }
  sensitive = true
}

variable "do_token" {
  description = "DigitalOcean API token"
  type        = string
  sensitive   = true
}
