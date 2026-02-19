output "dr_rds_endpoint" {
  description = "DR RDS endpoint"
  value       = aws_db_instance.dr_replica.endpoint
}

output "dr_rds_arn" {
  description = "DR RDS ARN"
  value       = aws_db_instance.dr_replica.arn
}