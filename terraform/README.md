# Terraform Components for `web-api`

This Terraform setup deploys the `web-api` application to three environments (`prod`, `staging`, and `dev`) while utilizing persistent state management through a Consul cluster. It also incorporates shared modules to provide modular and reusable infrastructure components.

## Environments

The `web-api` application is deployed to the following environments:

- **Production**: `/environments/prod/web-api`
- **Staging**: `/environments/staging/web-api`
- **Development**: `/environments/dev/web-api`

## State Management

Terraform state is stored persistently in a managed Consul cluster. This ensures consistent state management across all environments.

---

## Shared Modules

### 1. **`modules/application`**
   - **Description**: This module implements the API components, including the creation of an S3 bucket and a CloudFront distribution for the `web-api`.
   - **Features**:
     - Creates and configures an S3 bucket for hosting the application content.
     - Provisions a CloudFront distribution to enable global access with caching capabilities.
     - Configurable input variables for customizing the setup 
   - **Usage**:
     Refer to the module's README for detailed input/output specifications and example configurations.

### 2. **`lambda_application_trailing_slash`**
   - **Description**: A Lambda function designed for deployment to `Lambda@Edge`. It rewrites requests with trailing slashes to the `/index.html` suffix during the origin request phase in the CloudFront distribution.
   - **Features**:
     - Ensures that URLs with trailing slashes resolve correctly by appending `/index.html`.
     - Deployed globally via `Lambda@Edge` for low-latency request handling.
   - **Usage**:
     See the module's README for deployment instructions and configuration details.

---

## General Notes

- Each environment has its own Terraform configuration directory.
- The modules are designed to be reusable and configurable, allowing consistent and predictable infrastructure management.
- Make sure the Consul cluster is properly configured and accessible for Terraform to manage the state.
