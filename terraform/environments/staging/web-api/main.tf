module "origin_request_lambda" {
  source = "../../../modules/lambda_application_trailing_slash"

  name        = "rewrite-trailing-slash"
  app_name    = "web-api"
  app_owner   = "web-core-team"
  environment = "staging"
}

module "web_api_auth" {
  source = "../../../modules/application"

  app_name                       = "web-api"
  app_owner                      = "web-core-team"
  environment                    = "staging"
  app_component_index            = 1
  app_component                  = "auth"
  app_component_path_prefix      = "/auth"
  origin_request_lambda_edge_arn = module.origin_request_lambda.qualified_arn
}

module "web_api_info" {
  source = "../../../modules/application"

  app_name                       = "web-api"
  app_owner                      = "web-core-team"
  environment                    = "staging"
  app_component_index            = 2
  app_component                  = "info"
  app_component_path_prefix      = "/info"
  origin_request_lambda_edge_arn = module.origin_request_lambda.qualified_arn
}

module "web_api_customers" {
  source = "../../../modules/application"

  app_name                       = "web-api"
  app_owner                      = "web-core-team"
  environment                    = "staging"
  app_component_index            = 3
  app_component                  = "customers"
  app_component_path_prefix      = "/customers"
  origin_request_lambda_edge_arn = module.origin_request_lambda.qualified_arn
}

output "domains" {
  value = {
    auth      = module.web_api_auth.cloudfront_domain_name
    info      = module.web_api_info.cloudfront_domain_name
    customers = module.web_api_customers.cloudfront_domain_name
  }
}