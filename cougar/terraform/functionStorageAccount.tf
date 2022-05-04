resource "azurerm_storage_account" "functionStorageAccount" {
  name                     = "cougar${var.UniqueString}"
  location                 = var.ResourceGroupLocation
  resource_group_name      = azurerm_resource_group.cougar.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

data "archive_file" "functionapp" {
  type        = "zip"
  output_path = "${path.module}/functionapp.zip"

  source_dir = "../src/bin/Debug/netcoreapp3.1/publish"
}

# Reference: https://adrianhall.github.io/typescript/2019/10/23/terraform-functions/

resource "azurerm_storage_container" "deployments" {
  name = "function-releases"
  storage_account_name = azurerm_storage_account.functionStorageAccount.name
  container_access_type = "private"
}

resource "azurerm_storage_blob" "appcode" {
  name = data.archive_file.functionapp.output_path
  storage_account_name = azurerm_storage_account.functionStorageAccount.name
  storage_container_name = azurerm_storage_container.deployments.name
  type = "Block"
  source = data.archive_file.functionapp.output_path
}
