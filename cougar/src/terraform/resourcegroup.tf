resource "azurerm_resource_group" "cougar" {
  name     = "${var.resource_group_name}-${var.unique_identifier}"
  location = var.location
}
