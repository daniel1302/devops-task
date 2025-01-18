variable "name" {
  type        = string
  description = "Lambda name for origin request that trailing slash rewrite to index"
}

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