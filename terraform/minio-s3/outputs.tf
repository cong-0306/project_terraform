output "s3_bucket_name" {
  value = aws_s3_bucket.minio_backup.bucket
}