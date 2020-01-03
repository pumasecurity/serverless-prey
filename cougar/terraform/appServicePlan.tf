resource "azurerm_app_service_plan" "appServicePlan" {
  name                      = var.AppServicePlanName
  location                  = var.ResourceGroupLocation
  resource_group_name       = azurerm_resource_group.cougar.name
  kind                      = "FunctionApp"

  sku {
    tier = "Dynamic"
    size = "Y1"
  }
}
