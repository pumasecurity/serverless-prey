terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.33.0"
    }

    null = {
      source  = "hashicorp/null"
      version = "3.1.1"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.4.3"
    }

    template = {
      source  = "hashicorp/template"
      version = "2.2.0"
    }

    archive = {
      source  = "hashicorp/archive"
      version = "2.2.0"
    }

    local = {
      source  = "hashicorp/local"
      version = "2.2.3"
    }
  }
}

provider "aws" {
  profile = "$(var.profile}"
}
