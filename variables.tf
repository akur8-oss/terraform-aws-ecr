variable "name" {
  description = "Name of the repository."
  type        = string
}

variable "encryption_type" {
  type        = string
  description = "The encryption type to use for the repository. Valid values are AES256 or KMS."
  default     = "AES256"

  validation {
    condition     = var.encryption_type == "AES256" || var.encryption_type == "KMS"
    error_message = "The encryption_type value must be either `AES256` or `KMS`."
  }
}

variable "image_tag_mutability" {
  type        = bool
  description = "Tag mutability setting for the repository."
  default     = false
}

variable "kms_key" {
  type        = string
  description = "ARN of the KMS key to use when encryption_type is KMS. If not specified, uses the default AWS managed key for ECR."
  default     = null
}

variable "lifecycle_policy" {
  type        = string
  description = "Policy document. This is a JSON formatted string. See more details about [Policy Parameters](http://docs.aws.amazon.com/AmazonECR/latest/userguide/LifecyclePolicies.html#lifecycle_policy_parameters) in the official AWS docs."
  default     = ""
}

variable "replicated_region" {
  type        = list(string)
  description = "List of region in wich the repository is replicated."
  default     = []
}

variable "repository_policy" {
  type        = string
  description = "Policy document. This is a JSON formatted string. For more information about building IAM policy documents with Terraform, see the [AWS IAM Policy Document Guide](https://learn.hashicorp.com/terraform/aws/iam-policy)."
  default     = ""
}

variable "scan_on_push" {
  type        = bool
  description = "Indicates whether images are scanned after being pushed to the repository."
  default     = true
}

variable "tags" {
  description = "map of tags to assign to the resource. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}

variable "role_to_assume" {
  description = "The ARN of the role to assume when replicating repositories."
  type        = string
  default     = null
}
