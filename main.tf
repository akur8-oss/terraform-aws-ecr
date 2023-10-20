resource "aws_ecr_repository" "repository" {
  name = var.name

  image_tag_mutability = var.image_tag_mutability ? "MUTABLE" : "IMMUTABLE"
  tags                 = var.tags

  encryption_configuration {
    encryption_type = var.encryption_type
    kms_key         = var.kms_key
  }

  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }
}
resource "aws_ecr_lifecycle_policy" "lifecycle_policy" {
  count = length(var.lifecycle_policy) > 0 ? 1 : 0

  repository = aws_ecr_repository.repository.name
  policy     = var.lifecycle_policy
}

resource "null_resource" "replicate_lifecycle_policy" {
  for_each = length(var.lifecycle_policy) > 0 ? tolist(var.replicated_region) : tolist([])

  provisioner "local-exec" {
    command = "${path.module}/scripts/replicate-lifecycle-policy.sh"
    environment = {
      CURRENT_REGION = data.aws_region.current.name
      REPOSITORY     = var.name
      REGION         = each.key
      ROLE_TO_ASSUME = var.role_to_assume
    }
  }

  depends_on = [
    aws_ecr_repository.repository,
    aws_ecr_lifecycle_policy.lifecycle_policy
  ]

  triggers = {
    policy_hash = sha256(var.lifecycle_policy)
  }
}

resource "aws_ecr_repository_policy" "repository_policy" {
  count = length(var.repository_policy) > 0 ? 1 : 0

  repository = aws_ecr_repository.repository.name
  policy     = var.repository_policy
}

resource "null_resource" "replicate_repository_policy" {
  for_each = length(var.lifecycle_policy) > 0 ? tolist(var.replicated_region) : tolist([])

  provisioner "local-exec" {
    command = "${path.module}/scripts/replicate-repository-policy.sh"
    environment = {
      CURRENT_REGION = data.aws_region.current.name
      REPOSITORY     = var.name
      REGION         = each.value
      ROLE_TO_ASSUME = var.role_to_assume
    }
  }

  depends_on = [
    aws_ecr_repository.repository,
    aws_ecr_repository_policy.repository_policy
  ]

  triggers = {
    policy_hash = sha256(var.repository_policy)
  }
}
