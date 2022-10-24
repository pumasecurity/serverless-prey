resource "azurerm_service_plan" "plan" {
  name                = "serverless-prey-cougar-${var.unique_identifier}"
  location            = azurerm_resource_group.cougar.location
  resource_group_name = azurerm_resource_group.cougar.name
  os_type             = var.app_service_os_type
  sku_name            = var.app_service_plan_sku
}
