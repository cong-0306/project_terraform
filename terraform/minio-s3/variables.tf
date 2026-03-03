variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "project_name" {
  description = "Project name"
  type        = string
}

variable "s3_bucket_name" {
  description = "S3 bucket name for MinIO backup"
  type        = string
}

variable "existing_iam_user_name" {
  description = "Existing IAM user name for MinIO backup"
  type        = string
}