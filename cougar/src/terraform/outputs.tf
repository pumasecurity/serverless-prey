output "cougar_function_id" {
  value = var.app_service_os_type == "Linux" ? azurerm_linux_function_app.function_linux[0].id : ""
}

output "cougar_function_host" {
  value = var.app_service_os_type == "Linux" ? azurerm_linux_function_app.function_linux[0].default_hostname : ""
}
