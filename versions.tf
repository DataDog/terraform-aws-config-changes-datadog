locals {
  # Remember to add a changelog entry in the module's README when bumping this version
  terraform_module_version = "1.0.0"
}

terraform {
  required_version = ">= 1.8.4"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.5.0"
    }
  }
}
