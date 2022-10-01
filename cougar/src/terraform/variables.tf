variable "unique_identifier" {
  description = "This is a unique identifier use to uniquely name global resources."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group containing the Cougar resources."
  type        = string
  default     = "serverless-prey-cougar"
}

variable "location" {
  description = "The location of the resource group containing the Cougar resources."
  type        = string
  default     = "centralus"
}

variable "app_service_plan_sku" {
  description = "The service plan SKU."
  type        = string
  default     = "Y1"
}

variable "app_service_os_type" {
  description = "The kind of service plan to use for the app. Defaults to Linux. Use 'Windows' for a Windows runtime."
  type        = string
  default     = "Linux"
}

variable "configure_ctf" {
  description = "Create resources for Function CTF"
  type        = bool
  default     = false
}

variable "flag_prefix" {
  description = "Prefix for flag format (e.g. CloudWars{uuid})"
  type        = string
  default     = "CloudWars"
}
