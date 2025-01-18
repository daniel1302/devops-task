locals {
  common_tags = {
    app   = var.app_name
    env   = var.environment
    owner = var.app_owner
  }
}