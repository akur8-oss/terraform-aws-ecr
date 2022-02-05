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
  count = var.lifecycle_policy ? 1 : 0

  repository = aws_ecr_repository.repository.name
  policy     = var.lifecycle_policy
}

resource "aws_ecr_repository_policy" "repository_policy" {
  count = var.repository_policy ? 1 : 0

  repository = aws_ecr_repository.repository.name
  policy     = var.repository_policy
}
