terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.55.0"
    }

    null = {
      source  = "hashicorp/null"
      version = "3.1.1"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.4.3"
    }

    template = {
      source  = "hashicorp/template"
      version = "2.2.0"
    }

    archive = {
      source  = "hashicorp/archive"
      version = "2.2.0"
    }

    local = {
      source  = "hashicorp/local"
      version = "2.2.3"
    }
  }
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy    = false
      recover_soft_deleted_key_vaults = true
    }
  }
}
