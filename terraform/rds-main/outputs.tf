output "rds_endpoint" {
  description = "RDS endpoint"
  value       = aws_db_instance.main.endpoint
}

output "rds_arn" {
  description = "RDS ARN (for DR read replica)"
  value       = aws_db_instance.main.arn
}

output "rds_identifier" {
  description = "RDS identifier"
  value       = aws_db_instance.main.identifier
}