variable "pm_api_url" {
  description = "Proxmox API URL"
  type        = string
}

variable "pm_api_token_id" {
  description = "Proxmox API Token ID"
  type        = string
}

variable "pm_api_token_secret" {
  description = "Proxmox API Token Secret"
  type        = string
  sensitive   = true
}

variable "pm_tls_insecure" {
  description = "Allow insecure TLS connections"
  type        = bool
  default     = true
}

variable "ci_user" {
  description = "Cloud-init user for VM"
  type        = string
}

variable "ci_password" {
  description = "Cloud-init password for VM"
  type        = string
  sensitive   = true
}

