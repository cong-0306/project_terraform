output "rds_endpoint" {
  value = aws_db_instance.main.endpoint
}

output "rds_port" {
  value = aws_db_instance.main.port
}

output "rds_sg_id" {
  value = aws_security_group.rds.id
}

output "rds_replica_endpoint" {
  description = "Cross-region read replica endpoint"
  value       = aws_db_instance.replica.endpoint
}

output "rds_replica_region" {
  value = var.dr_region
}