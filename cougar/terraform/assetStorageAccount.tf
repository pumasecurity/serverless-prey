resource "azurerm_storage_account" "assetStorageAccount" {
  name                     = "cougarassets${var.UniqueString}"
  location                 = var.ResourceGroupLocation
  resource_group_name      = var.ResourceGroupName
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Reference: https://adrianhall.github.io/typescript/2019/10/23/terraform-functions/

resource "azurerm_storage_container" "assets" {
    name = "assets"
    storage_account_name = azurerm_storage_account.assetStorageAccount.name
    container_access_type = "private"
}

resource "azurerm_storage_blob" "cougar" {
    name = "cougar.jpg"
    storage_account_name = azurerm_storage_account.assetStorageAccount.name
    storage_container_name = azurerm_storage_container.assets.name
    type = "block"
    source = "../assets/cougar.jpg"
}
