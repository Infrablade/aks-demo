terraform {
  required_version = ">= 1.6"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.110"
    }
  }

  cloud {
    organization = "InfraBlade"

    workspaces {
      name = "aks-demo"
    }
  }
}

provider "azurerm" {
  features {}
}