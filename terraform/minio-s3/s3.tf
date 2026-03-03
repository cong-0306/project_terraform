resource "aws_s3_bucket" "minio_backup" {
  bucket = var.s3_bucket_name

  force_destroy = true

  tags = {
    Project = var.project_name
    Purpose = "minio-backup"
  }
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.minio_backup.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "block" {
  bucket = aws_s3_bucket.minio_backup.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}