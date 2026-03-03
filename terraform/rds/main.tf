resource "aws_db_subnet_group" "rds" {
  name       = "${var.db_identifier}-subnet-group"
  subnet_ids = var.db_subnet_ids
}

resource "aws_security_group" "rds" {
  name        = "${var.db_identifier}-sg"
  description = "RDS access from ROSA"
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "allow_pg_from_rosa" {
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  security_group_id        = aws_security_group.rds.id
  source_security_group_id = var.rosa_node_sg_id
}

resource "aws_security_group_rule" "egress_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.rds.id
}

resource "aws_db_instance" "main" {
  identifier = var.db_identifier

  engine         = "postgres"
  engine_version = var.engine_version
  instance_class = var.instance_class

  allocated_storage = var.allocated_storage
  storage_type      = "gp2"

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.rds.name
  vpc_security_group_ids = [aws_security_group.rds.id]

  publicly_accessible = var.publicly_accessible
  multi_az            = var.multi_az

  backup_retention_period = var.backup_retention_period
  # backup_replication_region = var.backup_replication_region

  storage_encrypted          = true
  auto_minor_version_upgrade = true

  enabled_cloudwatch_logs_exports = [
    "postgresql",
    "upgrade"
  ]

  deletion_protection = false
  skip_final_snapshot = true

  tags = var.tags
}

data "aws_kms_alias" "rds_dr" {
  provider = aws.dr
  name     = "alias/aws/rds"
}

################################
# Cross-Region Read Replica
################################
resource "aws_db_instance" "replica" {
  provider = aws.dr

  identifier = var.replica_identifier

  # ⭐ 핵심: Primary RDS를 복제 소스로 지정
  replicate_source_db = aws_db_instance.main.arn

  instance_class = var.replica_instance_class

  publicly_accessible = var.publicly_accessible
  multi_az            = false # Replica는 보통 Single-AZ

  # ⭐ Cross-Region Replica 필수 설정
  kms_key_id = data.aws_kms_alias.rds_dr.target_key_arn

  storage_encrypted = true

  skip_final_snapshot = true

  tags = merge(
    var.tags,
    {
      Role = "read-replica"
      DR   = "true"
    }
  )
}