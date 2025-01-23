locals {
  default_tags = {
    "terraform.managed"        = "true"
    "terraform.module"         = basename(path.module)
    "terraform.module.version" = local.terraform_module_version
  }

  tags = merge(local.default_tags, var.tags)
}
