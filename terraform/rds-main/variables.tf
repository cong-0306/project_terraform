# ---- 네트워크/연동 ----
variable "vpc_id" {
  description = "VPC ID where RDS will be created"
  type        = string
}

variable "db_subnet_ids" {
  description = "Subnet IDs (2+ AZs) for RDS subnet group"
  type        = list(string)
}

variable "rosa_worker_sg_id" {
  description = "ROSA worker node security group ID"
  type        = string
}

# ---- RDS 기본 ----
variable "db_identifier" {
  description = "RDS instance identifier"
  type        = string
}

variable "db_name" {
  description = "Initial database name"
  type        = string
}

variable "db_username" {
  description = "Master username"
  type        = string
}

variable "db_password" {
  description = "Master password"
  type        = string
  sensitive   = true
}

variable "engine_version" {
  description = "PostgreSQL engine version"
  type        = string
  default     = "15.4"
}

variable "instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro" # dev/test
}

variable "allocated_storage" {
  description = "Allocated storage (GB)"
  type        = number
  default     = 20
}

variable "backup_retention_period" {
  description = "Automated backup retention days (>=1 required for read replica)"
  type        = number
  default     = 7
}