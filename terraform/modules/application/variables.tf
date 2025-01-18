variable "app_name" {
  type        = string
  description = "An application name"

  validation {
    condition     = length(var.app_name) > 0
    error_message = "The app_name cannot be empty"
  }
}

variable "app_owner" {
  type        = string
  description = "An application owner(person/team developers should contact to)"

  validation {
    condition     = length(var.app_owner) > 0
    error_message = "The app_owner cannot be empty"
  }
}

variable "environment" {
  type        = string
  description = "An application environment"

  validation {
    condition     = contains(["prod", "staging", "dev"], var.environment)
    error_message = "The environment must be one of prod, staging, dev"
  }
}

variable "app_component_index" {
  type        = number
  description = "The index of the application component"
}


variable "app_component" {
  type        = string
  description = "The component name of the web-application (e.g: info, auth, customers, ...)"

  validation {
    condition     = length(var.app_component) > 0
    error_message = "The app_component cannot be empty"
  }
}

variable "app_component_path_prefix" {
  type        = string
  description = "The path prefix for the application component. Must start with /"

  validation {
    condition     = length(var.app_component_path_prefix) > 0 && startswith(var.app_component_path_prefix, "/")
    error_message = "The app_component_path_prefix cannot be empty and should start with /"
  }
}

variable "origin_request_lambda_edge_arn" {
  type        = string
  description = "Qualified arn for the origin_request lambda"
  default     = ""
}

variable "alternate_domain_names" {
  type        = list(string)
  description = "Additional domain names for cloudfront"
  default     = []
}