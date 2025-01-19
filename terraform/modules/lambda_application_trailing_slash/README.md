<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | n/a |
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_role.lambda_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_lambda_function.origin_request_lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [archive_file.origin_request_lambda](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_name"></a> [app\_name](#input\_app\_name) | An application name | `string` | n/a | yes |
| <a name="input_app_owner"></a> [app\_owner](#input\_app\_owner) | An application owner(person/team developers should contact to) | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | An application environment | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Lambda name for origin request that trailing slash rewrite to index | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_qualified_arn"></a> [qualified\_arn](#output\_qualified\_arn) | n/a |
<!-- END_TF_DOCS -->