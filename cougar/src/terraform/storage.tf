resource "azurerm_storage_account" "function" {
  name                     = "cougar${var.unique_identifier}"
  location                 = var.location
  resource_group_name      = azurerm_resource_group.cougar.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "function_cougar" {
  name                  = "cougar"
  storage_account_name  = azurerm_storage_account.function.name
  container_access_type = "private"
}

resource "random_uuid" "cougar_config_flag" {
  count = var.configure_ctf ? 1 : 0
}

resource "random_string" "cougar_config_name" {
  count = var.configure_ctf ? 1 : 0

  length  = 8
  special = false
  upper   = false
  lower   = true
  numeric = true
}

resource "random_uuid" "courgar_storage_flag" {
  count = var.configure_ctf ? 1 : 0
}

resource "azurerm_storage_blob" "function_cougar" {
  name                   = "functionapp.zip"
  storage_account_name   = azurerm_storage_account.function.name
  storage_container_name = azurerm_storage_container.function_cougar.name
  type                   = "Block"
  source                 = "${path.module}/../functionapp.zip"
}

resource "azurerm_storage_account" "assets" {
  count = var.configure_ctf ? 1 : 0

  name                     = "cougar${random_string.cougar_config_name[0].id}"
  location                 = azurerm_resource_group.cougar.location
  resource_group_name      = azurerm_resource_group.cougar.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "assets" {
  count = var.configure_ctf ? 1 : 0

  name                  = "assets"
  storage_account_name  = azurerm_storage_account.assets[0].name
  container_access_type = "private"
}

resource "random_uuid" "cougar_storage_flag" {
  count = var.configure_ctf ? 1 : 0
}

resource "azurerm_storage_blob" "cougar" {
  count = var.configure_ctf ? 1 : 0

  name                   = "cougar.jpg"
  storage_account_name   = azurerm_storage_account.assets[0].name
  storage_container_name = azurerm_storage_container.assets[0].name
  type                   = "Block"
  source                 = "../../assets/cougar.jpg"

  metadata = {
    flag = "${var.flag_prefix}{${random_uuid.cougar_storage_flag[0].id}}"
  }
}
