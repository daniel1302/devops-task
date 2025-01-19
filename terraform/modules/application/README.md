<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudfront_distribution.distribution](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution) | resource |
| [aws_cloudfront_origin_access_control.cloudfront_oac](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_origin_access_control) | resource |
| [aws_s3_bucket.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_policy.static_site_bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_public_access_block.block_public_access_for_static_sites](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.default_encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_versioning.default_versioning](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_s3_object.default_404_content](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object) | resource |
| [aws_s3_object.default_index_content](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object) | resource |
| [aws_iam_policy_document.s3_bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alternate_domain_names"></a> [alternate\_domain\_names](#input\_alternate\_domain\_names) | Additional domain names for cloudfront | `list(string)` | `[]` | no |
| <a name="input_app_component"></a> [app\_component](#input\_app\_component) | The component name of the web-application (e.g: info, auth, customers, ...) | `string` | n/a | yes |
| <a name="input_app_component_index"></a> [app\_component\_index](#input\_app\_component\_index) | The index of the application component | `number` | n/a | yes |
| <a name="input_app_component_path_prefix"></a> [app\_component\_path\_prefix](#input\_app\_component\_path\_prefix) | The path prefix for the application component. Must start with / | `string` | n/a | yes |
| <a name="input_app_name"></a> [app\_name](#input\_app\_name) | An application name | `string` | n/a | yes |
| <a name="input_app_owner"></a> [app\_owner](#input\_app\_owner) | An application owner(person/team developers should contact to) | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | An application environment | `string` | n/a | yes |
| <a name="input_origin_request_lambda_edge_arn"></a> [origin\_request\_lambda\_edge\_arn](#input\_origin\_request\_lambda\_edge\_arn) | Qualified arn for the origin\_request lambda | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bucket_id"></a> [bucket\_id](#output\_bucket\_id) | n/a |
| <a name="output_cloudfront_arn"></a> [cloudfront\_arn](#output\_cloudfront\_arn) | n/a |
| <a name="output_cloudfront_domain_name"></a> [cloudfront\_domain\_name](#output\_cloudfront\_domain\_name) | n/a |
<!-- END_TF_DOCS -->