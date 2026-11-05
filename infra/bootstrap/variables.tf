variable "subscription_id" {
  description = "Azure subscription ID. Pass it at run time."
  type        = string
  sensitive   = true
}

variable "location" {
  description = "Azure region for the state storage."
  type        = string
  default     = "switzerlandnorth"
}

variable "storage_account_name" {
  description = "Globally unique storage account name."
  type        = string
  default     = "stalpenlogiklabtf"
}

variable "github_repository" {
  description = "GitHub repository allowed to use the identities."
  type        = string
  default     = "vidal-renao/alpenlogik-infra"
}
