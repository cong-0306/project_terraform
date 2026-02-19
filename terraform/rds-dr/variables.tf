# ---- Main RDS 정보 (rds-main output) ----
variable "source_db_instance_arn" {
  description = "Main RDS ARN (Seoul)"
  type        = string
}

variable "source_region" {
  description = "Source region of main RDS (Seoul)"
  type        = string
  default     = "ap-northeast-2"
}

# ---- DR 네트워크 정보 ----
variable "dr_vpc_id" {
  description = "DR VPC ID (Singapore)"
  type        = string
}

variable "dr_subnet_ids" {
  description = "Subnet IDs for DR RDS subnet group"
  type        = list(string)
}

variable "dr_rds_sg_id" {
  description = "Security group ID for DR RDS"
  type        = string
}

# ---- DR RDS 설정 ----
variable "dr_identifier" {
  description = "Identifier for DR read replica"
  type        = string
}