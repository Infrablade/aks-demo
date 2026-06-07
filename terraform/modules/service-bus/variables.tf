variable "name" {
  description = "Service Bus namespace name"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group to deploy into"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "sku" {
  description = "Service Bus SKU"
  type        = string
  default     = "Standard"

  validation {
    condition     = contains(["Basic", "Standard", "Premium"], var.sku)
    error_message = "SKU must be Basic, Standard, or Premium."
  }
}

variable "topic_name" {
  description = "Service Bus topic name"
  type        = string
  default     = "tax-code-updates"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}