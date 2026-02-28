variable "app_name" {
  description = "Name of the DigitalOcean App"
  type        = string
  default     = "svelte-mine-game"
}

variable "region" {
  description = "DigitalOcean region where the app will be deployed"
  type        = string
  default     = "nyc"
}

variable "instance_size_slug" {
  description = "Instance size for the app (basic-xxs is appropriate for starter tier SvelteKit apps)"
  type        = string
  default     = "basic-xxs"
}

variable "instance_count" {
  description = "Number of instances to run"
  type        = number
  default     = 1
}

variable "github_repo" {
  description = "GitHub repository in format: owner/repo"
  type        = string
  default     = "douglasswm/svelte-mine-game"
}

variable "github_branch" {
  description = "Git branch to deploy from"
  type        = string
  default     = "main"
}

variable "deploy_on_push" {
  description = "Automatically deploy when changes are pushed to the branch"
  type        = bool
  default     = true
}

variable "build_command" {
  description = "Build command for SvelteKit application"
  type        = string
  default     = "npm run build"
}

variable "run_command" {
  description = "Command to run the application"
  type        = string
  default     = "node build"
}

variable "node_version" {
  description = "Node.js version to use for building and running the app"
  type        = string
  default     = "20"
}
