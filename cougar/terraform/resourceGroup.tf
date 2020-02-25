provider "azurerm" {
  version = "=1.42.0"
}

resource "azurerm_resource_group" "cougar" {
  name     = "Cougar"
  location = var.ResourceGroupLocation
}
