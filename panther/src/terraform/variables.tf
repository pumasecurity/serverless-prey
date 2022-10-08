variable "unique_identifier" {
  description = "This is a unique identifier use to uniquely name global resources."
  type        = string
}

variable "profile" {
  description = "The AWS profile in the local ~/.aws/config file to use for authentication."
  type        = string
  default     = "default"
}

variable "partition" {
  description = "AWS partition for ARN and URL construction."
  type        = string
  default     = "aws"

  validation {
    condition     = var.partition == "aws" || var.partition == "aws-us-gov"
    error_message = "The AWS partition must be a valid value: [aws-us-gov|aws]."
  }
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

variable "global_tags" {
  description = "Global resource tags to be applied to all resources in this module."
  type        = map(string)
  default = {
    product = "serverless prey"
  }
}
