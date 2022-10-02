output "cougar_function_id" {
  value = var.app_service_os_type == "Linux" ? azurerm_linux_function_app.function[0].id : azurerm_windows_function_app.function[0].id
}

output "cougar_function_host" {
  value = var.app_service_os_type == "Linux" ? azurerm_linux_function_app.function[0].default_hostname : azurerm_windows_function_app.function[0].default_hostname
}
