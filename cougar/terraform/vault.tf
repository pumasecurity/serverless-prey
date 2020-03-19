data "azurerm_client_config" "current" {
}

resource "azurerm_key_vault" "vault" {
  name                = "cougar${var.UniqueString}"
  location            = azurerm_resource_group.cougar.location
  resource_group_name = azurerm_resource_group.cougar.name
  tenant_id           = data.azurerm_client_config.current.tenant_id

  sku_name = "standard"
}

resource "azurerm_key_vault_access_policy" "owner" {
  key_vault_id = azurerm_key_vault.vault.id

  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = data.azurerm_client_config.current.object_id

  secret_permissions = ["delete", "get", "list", "set"]
}

resource "azurerm_key_vault_access_policy" "function" {
  key_vault_id = azurerm_key_vault.vault.id

  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = azurerm_function_app.functionApp.identity[0].principal_id

  secret_permissions = ["get", "list"]
}

resource "azurerm_key_vault_secret" "db_user" {
  depends_on   = [azurerm_key_vault_access_policy.owner]

  name         = "cougar-database-user"
  value        = "panther_user"
  key_vault_id = azurerm_key_vault.vault.id
}

resource "azurerm_key_vault_secret" "db_password" {
  depends_on   = [azurerm_key_vault_access_policy.owner]

  name         = "cougar-database-password"
  value        = "RG9ncyBhcmUgb3VyIGxpbmsgdG8gcGFyYWRpc2UuIFRoZXkgZG9uJ3Qga25vdyBldmlsIG9yIGplYWxvdXN5IG9yIGRpc2NvbnRlbnQu"
  key_vault_id = azurerm_key_vault.vault.id
}
