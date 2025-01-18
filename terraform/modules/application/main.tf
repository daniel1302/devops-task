locals {
  common_tags = {
    app                 = var.app_name
    env                 = var.environment
    owner               = var.app_owner
    app_component       = var.app_component
    app_component_index = var.app_component_index
  }
}
