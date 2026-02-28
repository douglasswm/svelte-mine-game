variable "app_name" {
  description = "Name of the DigitalOcean App"
  type        = string
  default     = "svelte-mine-game"
}

variable "region" {
  description = "DigitalOcean region for the app"
  type        = string
  default     = "nyc"
}

variable "github_repo" {
  description = "GitHub repository in format 'owner/repo'"
  type        = string
  default     = "douglasswm/svelte-mine-game"
}

variable "github_branch" {
  description = "GitHub branch to deploy"
  type        = string
  default     = "main"
}

variable "deploy_on_push" {
  description = "Automatically deploy when code is pushed to the branch"
  type        = bool
  default     = true
}

variable "build_command" {
  description = "Command to build the application"
  type        = string
  default     = "npm run build"
}

variable "run_command" {
  description = "Command to run the application"
  type        = string
  default     = "node build"
}

variable "instance_count" {
  description = "Number of instances to run"
  type        = number
  default     = 1
}

variable "instance_size_slug" {
  description = "Size of the app instance (basic-xxs for starter tier)"
  type        = string
  default     = "basic-xxs"
}
