terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.53"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.1.0"
    }
  }

  required_version = "~> 1.0"
}
