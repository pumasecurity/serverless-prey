# Reference: https://adrianhall.github.io/typescript/2019/10/23/terraform-functions/
data "azurerm_storage_account_sas" "sas" {
  connection_string = "${azurerm_storage_account.functionStorageAccount.primary_connection_string}"
  https_only = true
  start = formatdate("YYYY-MM-DD", timeadd(timestamp(), "-48h"))
  expiry = formatdate("YYYY-MM-DD", timeadd(timestamp(), "17520h"))

  resource_types {
    object = true
    container = false
    service = false
  }

  services {
    blob = true
    queue = false
    table = false
    file = false
  }

  permissions {
    read = true
    write = false
    delete = false
    list = false
    add = false
    create = false
    update = false
    process = false
  }
}

resource "azurerm_function_app" "functionApp" {
  name                      = "cougar${var.UniqueString}"
  location                  = azurerm_resource_group.cougar.location
  resource_group_name       = azurerm_resource_group.cougar.name
  app_service_plan_id       = azurerm_app_service_plan.appServicePlan.id
  storage_connection_string = azurerm_storage_account.functionStorageAccount.primary_connection_string
  version                   = "~3"

  app_settings = {
    FUNCTIONS_WORKER_RUNTIME = "dotnet"
    FUNCTION_APP_EDIT_MODE = "readonly"
    HASH = "${base64encode(filesha256(data.archive_file.functionapp.output_path))}"
    WEBSITE_RUN_FROM_PACKAGE = "https://${azurerm_storage_account.functionStorageAccount.name}.blob.core.windows.net/${azurerm_storage_container.deployments.name}/${azurerm_storage_blob.appcode.name}${data.azurerm_storage_account_sas.sas.sas}"
  }

  identity {
    type = "SystemAssigned"
  }
}
