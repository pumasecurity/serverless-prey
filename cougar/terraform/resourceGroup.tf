terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.93.0"
    }

    archive = {
      source  = "hashicorp/archive"
      version = "2.2.0"
    }
  }
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = false
    }
  }
}


resource "azurerm_resource_group" "cougar" {
  name     = var.ResourceGroupName
  location = var.ResourceGroupLocation
}
