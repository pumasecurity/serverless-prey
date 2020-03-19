data "azurerm_subscription" "current" {
}

locals {
  scope = "${data.azurerm_subscription.current.id}/resourceGroups/${azurerm_resource_group.cougar.name}"
}

resource "azurerm_role_definition" "cougar" {
  name              = "cougar${var.UniqueString}"
  scope             = local.scope

  permissions {
    actions      = ["Microsoft.Storage/*/read", "Microsoft.KeyVault/vaults/secrets/read"]
    data_actions = ["Microsoft.Storage/*/read", "Microsoft.KeyVault/vaults/secrets/getSecret/action"]
  }

  assignable_scopes = [
    local.scope
  ]
}

resource "azurerm_role_assignment" "cougar" {
  scope              = local.scope
  role_definition_id = azurerm_role_definition.cougar.id
  principal_id       = azurerm_function_app.functionApp.identity[0].principal_id
}
