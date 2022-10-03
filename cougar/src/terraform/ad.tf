locals {
  scope = "${data.azurerm_subscription.current.id}/resourceGroups/${azurerm_resource_group.cougar.name}"
}

resource "azurerm_role_definition" "cougar" {
  count = var.configure_ctf ? 1 : 0

  name  = "cougar${var.unique_identifier}"
  scope = local.scope

  permissions {
    actions      = ["Microsoft.Storage/*/read", "Microsoft.KeyVault/vaults/secrets/read"]
    data_actions = ["Microsoft.Storage/*/read", "Microsoft.KeyVault/vaults/secrets/getSecret/action"]
  }

  assignable_scopes = [
    local.scope
  ]
}

resource "azurerm_role_assignment" "cougar" {
  count = var.configure_ctf ? 1 : 0

  scope              = local.scope
  role_definition_id = azurerm_role_definition.cougar[0].role_definition_resource_id
  principal_id       = var.app_service_os_type == "Linux" ? azurerm_linux_function_app.function[0].identity[0].principal_id : azurerm_windows_function_app.function[0].identity[0].principal_id
}
