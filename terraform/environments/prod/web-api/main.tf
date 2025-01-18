module "application" {
  source = "../../../modules/application"

  app_name    = "web-api"
  app_owner   = "web-core-team"
  environment = "prod"
}
