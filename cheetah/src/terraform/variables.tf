variable "unique_identifier" {
  description = "This is a unique identifier associated with AWS that must be the same on every Terraform run. It will be used to create infrastructure that needs a globally unique name (Ex. cloud storage buckets)."
  type        = string
}

variable "project_id" {
  description = "The Google Cloud Platform project ID."
  type        = string
}

variable "region" {
  description = "The Google Cloud Platform region for all the resources."
  type        = string
  default     = "us-east1"
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
