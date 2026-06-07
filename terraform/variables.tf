variable "resource_group_name" {
  description = "Name of the Azure resource group"
  type        = string
  default     = "rg-aks-demo"
}

variable "location" {
  description = "Azure region to deploy into"
  type        = string
  default     = "uksouth"
}

variable "acr_name" {
  description = "Container registry name (globally unique, alphanumeric only)"
  type        = string
  default     = "acraksdemo"
}

variable "aks_name" {
  description = "AKS cluster name"
  type        = string
  default     = "aks-demo"
}

variable "node_count" {
  description = "Number of nodes in the AKS node pool"
  type        = number
  default     = 1
}

variable "node_vm_size" {
  description = "VM size for AKS nodes"
  type        = string
  default     = "Standard_B2s"
}