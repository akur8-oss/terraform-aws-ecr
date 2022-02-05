output "arn" {
  description = "Full ARN of the repository."
  value       = aws_ecr_repository.repository.arn
}

output "repository_url" {
  description = "URL of the repository (in the form `aws_account_id.dkr.ecr.region.amazonaws.com/repositoryName`)."
  value       = aws_ecr_repository.repository.repository_url
}
