variable "primary_region" {
  description = "AWS region"
  type        = string
}

variable "dr_region" {
  description = "DR (replica) region"
  type        = string
}

variable "vpc_id" {
  description = "ROSA VPC ID"
  type        = string
}

variable "db_subnet_ids" {
  description = "RDS subnet IDs"
  type        = list(string)
}

variable "rosa_node_sg_id" {
  description = "ROSA worker node security group ID"
  type        = string
}

variable "db_identifier" {
  description = "RDS identifier"
  type        = string
}

variable "db_name" {
  type = string
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "engine_version" {
  type = string
}

variable "instance_class" {
  type = string
}

variable "allocated_storage" {
  type = number
}

variable "backup_retention_period" {
  type = number
}

variable "backup_replication_region" {
  type = string
}

variable "replica_identifier" {
  description = "Read replica DB identifier"
  type        = string
}

variable "replica_instance_class" {
  description = "Instance class for read replica"
  type        = string
}

variable "publicly_accessible" {
  type = bool
}

variable "multi_az" {
  type = bool
}

variable "tags" {
  type = map(string)
}