variable "container_image" {
  description = "Versioned container image."
  type        = string
  default     = "mcr.microsoft.com/k8se/quickstart:latest"
}

variable "target_port" {
  description = "Container port."
  type        = number
  default     = 80
}

variable "revision_suffix" {
  description = "Unique suffix for the Container Apps revision."
  type        = string
  default     = "v0"
}
