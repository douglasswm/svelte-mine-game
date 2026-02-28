variable "app_name" {
  description = "Name of the DigitalOcean App"
  type        = string
  default     = "svelte-minesweeper"
}

variable "region" {
  description = "DigitalOcean region for app deployment"
  type        = string
  default     = "nyc"
}

variable "github_repo" {
  description = "GitHub repository in the format owner/repo"
  type        = string
  default     = "douglasswm/svelte-mine-game"
}

variable "github_branch" {
  description = "GitHub branch to deploy from"
  type        = string
  default     = "main"
}

variable "build_command" {
  description = "Build command for the SvelteKit application"
  type        = string
  default     = "npm run build"
}

variable "output_directory" {
  description = "Output directory for built static files"
  type        = string
  default     = ".svelte-kit"
}

variable "auto_deploy" {
  description = "Enable automatic deployments on git push"
  type        = bool
  default     = true
}
