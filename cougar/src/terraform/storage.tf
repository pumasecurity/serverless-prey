resource "azurerm_storage_account" "function" {
  name                     = "serverlessprey${var.unique_identifier}"
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

data "template_file" "cougar_config" {
  template = file("${path.module}/../../assets/appsettings.tpl")
  vars = {
    database_password = var.configure_ctf ? "${var.flag_prefix}{${random_uuid.cougar_config_flag[0].id}}" : "QnV0IHVuaWNvcm5zIGFwcGFyZW50bHkgZG8gZXhpc3Qu"
    storage_account   = "cougar${var.configure_ctf ? random_string.cougar_config_name[0].id : var.unique_identifier}"
    storage_container = "assets"
  }
}

resource "local_file" "cougar_config" {
  filename = "${path.module}/../cougar/appsettings.json"
  content  = data.template_file.cougar_config.rendered
}

resource "null_resource" "cougar_build" {
  depends_on = [
    azurerm_storage_container.function_cougar,
    local_file.cougar_config,
  ]

  provisioner "local-exec" {
    working_dir = "${path.module}/../cougar"
    command     = <<-EOT
        dotnet publish --output "./../publish" --configuration "Release" /p:GenerateRuntimeConfigurationFiles=true --runtime linux-x64 --self-contained false
    EOT
  }

  triggers = {
    deploy = timestamp()
  }
}

data "archive_file" "cougar_build" {
  depends_on = [null_resource.cougar_build]

  type        = "zip"
  source_dir  = "${path.module}/../publish"
  output_path = "${path.module}/../functionapp.zip"
}

resource "azurerm_storage_blob" "function_cougar" {
  name                   = "functionapp.zip"
  storage_account_name   = azurerm_storage_account.function.name
  storage_container_name = azurerm_storage_container.function_cougar.name
  type                   = "Block"
  source                 = data.archive_file.cougar_build.output_path
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
