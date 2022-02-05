# terraform-aws-ecr

This module is used to create AWS Elastic Containers Repositories and apply policies on them and their replicas.

## Usage

### Use the module

```hcl
module "ecr" {
  source = "./"

  name = "repositoryName"
}
```

<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement_terraform) | ~> 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement_aws) | ~> 3.0 |
| <a name="requirement_null"></a> [null](#requirement_null) | ~> 3.1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider_aws) | ~> 3.0 |
| <a name="provider_null"></a> [null](#provider_null) | ~> 3.1.0 |

## Resources

| Name | Type |
|------|------|
| [aws_ecr_lifecycle_policy.lifecycle_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_lifecycle_policy) | resource |
| [aws_ecr_repository.repository](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository) | resource |
| [aws_ecr_repository_policy.repository_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository_policy) | resource |
| [null_resource.replicate_lifecycle_policy](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.replicate_repository_policy](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input_name) | Name of the repository. | `string` | n/a | yes |
| <a name="input_encryption_type"></a> [encryption_type](#input_encryption_type) | The encryption type to use for the repository. Valid values are AES256 or KMS. | `string` | `"AES256"` | no |
| <a name="input_image_tag_mutability"></a> [image_tag_mutability](#input_image_tag_mutability) | Tag mutability setting for the repository. | `bool` | `false` | no |
| <a name="input_kms_key"></a> [kms_key](#input_kms_key) | ARN of the KMS key to use when encryption_type is KMS. If not specified, uses the default AWS managed key for ECR. | `string` | `null` | no |
| <a name="input_lifecycle_policy"></a> [lifecycle_policy](#input_lifecycle_policy) | Policy document. This is a JSON formatted string. See more details about [Policy Parameters](http://docs.aws.amazon.com/AmazonECR/latest/userguide/LifecyclePolicies.html#lifecycle_policy_parameters) in the official AWS docs. | `string` | `""` | no |
| <a name="input_replicated_region"></a> [replicated_region](#input_replicated_region) | List of region in wich the repository is replicated. | `list(string)` | `[]` | no |
| <a name="input_repository_policy"></a> [repository_policy](#input_repository_policy) | Policy document. This is a JSON formatted string. For more information about building IAM policy documents with Terraform, see the [AWS IAM Policy Document Guide](https://learn.hashicorp.com/terraform/aws/iam-policy). | `string` | `""` | no |
| <a name="input_scan_on_push"></a> [scan_on_push](#input_scan_on_push) | Indicates whether images are scanned after being pushed to the repository. | `bool` | `true` | no |
| <a name="input_tags"></a> [tags](#input_tags) | map of tags to assign to the resource. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output_arn) | Full ARN of the repository. |
| <a name="output_repository_url"></a> [repository_url](#output_repository_url) | URL of the repository (in the form `aws_account_id.dkr.ecr.region.amazonaws.com/repositoryName`). |
<!-- END_TF_DOCS -->
