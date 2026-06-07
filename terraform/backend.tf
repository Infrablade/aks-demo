# Azure Blob Storage backend
# Uncomment this and comment out the cloud {} block in versions.tf
# to migrate state from TFC to Azure Blob Storage

# terraform {
#   backend "azurerm" {
#     resource_group_name  = "rg-tfstate"
#     storage_account_name = "sttfstateinfrablade"
#     container_name       = "tfstate"
#     key                  = "aks-demo.terraform.tfstate"
#   }
# }