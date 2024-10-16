data "azurerm_storage_account_sas" "sas" {
  connection_string = azurerm_storage_account.function.primary_connection_string
  https_only        = true
  start             = formatdate("YYYY-MM-DD", timeadd(timestamp(), "-48h"))
  expiry            = formatdate("YYYY-MM-DD", timeadd(timestamp(), "17520h"))

  resource_types {
    object    = true
    container = false
    service   = false
  }

  services {
    blob  = true
    queue = false
    table = false
    file  = false
  }

  permissions {
    read    = true
    write   = false
    delete  = false
    list    = false
    add     = false
    create  = false
    update  = false
    process = false
    tag     = false
    filter  = false
  }
}

resource "azurerm_linux_function_app" "function" {
  count = var.app_service_os_type == "Linux" ? 1 : 0

  name                = "cougar${var.unique_identifier}"
  location            = azurerm_resource_group.cougar.location
  resource_group_name = azurerm_resource_group.cougar.name

  service_plan_id             = azurerm_service_plan.plan.id
  storage_account_name        = azurerm_storage_account.function.name
  storage_account_access_key  = azurerm_storage_account.function.primary_access_key
  functions_extension_version = "~4"

  site_config {
    ftps_state = "Disabled"

    application_stack {
      dotnet_version = "8.0"
    }
  }

  app_settings = {
    FUNCTION_APP_EDIT_MODE   = "readonly"
    HASH                     = filebase64sha256("${path.module}/../functionapp.zip")
    WEBSITE_RUN_FROM_PACKAGE = "https://${azurerm_storage_account.function.name}.blob.core.windows.net/${azurerm_storage_container.function_cougar.name}/${azurerm_storage_blob.function_cougar.name}${data.azurerm_storage_account_sas.sas.sas}"
    COUGAR_KEY_VAULT_URL     = var.configure_ctf ? azurerm_key_vault.vault[0].vault_uri : ""
    COUGAR_SECRET_NAME       = var.configure_ctf ? azurerm_key_vault_secret.cougar[0].name : ""
  }

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_windows_function_app" "function" {
  count = var.app_service_os_type == "Windows" ? 1 : 0

  name                = "cougar${var.unique_identifier}"
  location            = azurerm_resource_group.cougar.location
  resource_group_name = azurerm_resource_group.cougar.name

  service_plan_id             = azurerm_service_plan.plan.id
  storage_account_name        = azurerm_storage_account.function.name
  storage_account_access_key  = azurerm_storage_account.function.primary_access_key
  functions_extension_version = "~4"

  site_config {
    ftps_state = "Disabled"

    application_stack {
      dotnet_version = "v8.0"
    }
  }

  app_settings = {
    FUNCTION_APP_EDIT_MODE   = "readonly"
    HASH                     = filebase64sha256("${path.module}/../functionapp.zip")
    WEBSITE_RUN_FROM_PACKAGE = "https://${azurerm_storage_account.function.name}.blob.core.windows.net/${azurerm_storage_container.function_cougar.name}/${azurerm_storage_blob.function_cougar.name}${data.azurerm_storage_account_sas.sas.sas}"
    COUGAR_KEY_VAULT_URL     = ""
    COUGAR_SECRET_NAME       = ""
  }

  identity {
    type = "SystemAssigned"
  }
}
