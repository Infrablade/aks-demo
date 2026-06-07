variable "name" {
  description = "Key Vault name (globally unique, 3-24 chars)"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9-]{3,24}$", var.name))
    error_message = "Key Vault name must be 3-24 alphanumeric characters or hyphens."
  }
}

variable "resource_group_name" {
  description = "Resource group to deploy into"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "tenant_id" {
  description = "Azure tenant ID"
  type        = string
}

variable "sp_object_id" {
  description = "Service Principal object ID for Key Vault admin access"
  type        = string
}

variable "user_object_id" {
  description = "Your personal account object ID for Key Vault admin access"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}