# Reference: https://github.com/markgossa/HashiTalk1-TerraformModules

variable "UniqueString" {
  description = "This is a unique identifier that must be the same on every Terraform run. It will be used to create two storage accounts and function app."
  type = string
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
