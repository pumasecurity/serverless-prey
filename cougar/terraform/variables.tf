# Reference: https://github.com/markgossa/HashiTalk1-TerraformModules

variable "UniqueString" {
  description = "This is a unique identifier that must be the same on every Terraform run. It will be used to create two storage accounts and function app."
  type = string
}

variable "ResourceGroupName" {
  description = "The name of the resource group containing the Cougar resources."
  type = string
  default = "Cougar"
}

variable "ResourceGroupLocation" {
  description = "The location of the resource group containing the Cougar resources."
  type = string
  default = "centralus"
}

variable "AppServicePlanName" {
  description = "The service plan with which to run the app."
  type = string
  default = "ConsumptionPlanASP"
}

variable "AppServicePlanKind" {
  description = "The kind of service plan to use for the app. Defaults to Linux. Use 'FunctionApp' for a Windows runtime."
  type = string
  default = "Linux"
}
