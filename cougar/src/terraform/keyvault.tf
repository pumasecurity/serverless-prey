resource "random_string" "key_vault" {
  count = var.configure_ctf ? 1 : 0

  length  = 8
  special = false
  upper   = false
  lower   = true
  numeric = true
}

resource "random_uuid" "cougar_secret_name" {
  count = var.configure_ctf ? 1 : 0
}

resource "random_uuid" "cougar_secret_flag" {
  count = var.configure_ctf ? 1 : 0
}

resource "azurerm_key_vault" "vault" {
  count = var.configure_ctf ? 1 : 0

  name                = "cougar${random_string.key_vault[0].id}"
  location            = azurerm_resource_group.cougar.location
  resource_group_name = azurerm_resource_group.cougar.name
  tenant_id           = data.azurerm_client_config.current.tenant_id

  sku_name = "standard"
}

resource "azurerm_key_vault_access_policy" "owner" {
  count = var.configure_ctf ? 1 : 0

  key_vault_id = azurerm_key_vault.vault[0].id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  secret_permissions = ["Delete", "Get", "List", "Set"]
}

resource "azurerm_key_vault_access_policy" "function" {
  count = var.configure_ctf ? 1 : 0

  key_vault_id = azurerm_key_vault.vault[0].id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = var.app_service_os_type == "Linux" ? azurerm_linux_function_app.function[0].identity[0].principal_id : azurerm_windows_function_app.function[0].identity[0].principal_id

  secret_permissions = ["Get", "List"]
}

resource "azurerm_key_vault_secret" "cougar" {
  count = var.configure_ctf ? 1 : 0

  depends_on = [azurerm_key_vault_access_policy.owner]

  key_vault_id = azurerm_key_vault.vault[0].id
  name         = "cougar-${random_uuid.cougar_secret_name[0].id}"
  value        = "${var.flag_prefix}{${random_uuid.cougar_secret_flag[0].id}}"
}
