# -----------------------------
# RDS Subnet Group
# -----------------------------
resource "aws_db_subnet_group" "rds_subnet" {
  name       = "${var.db_identifier}-subnet-group"
  subnet_ids = var.db_subnet_ids

  tags = {
    Name = "${var.db_identifier}-subnet-group"
  }
}

# -----------------------------
# RDS Security Group
# -----------------------------
resource "aws_security_group" "rds_sg" {
  name        = "${var.db_identifier}-sg"
  description = "RDS PostgreSQL SG"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.db_identifier}-sg"
  }
}

# Allow PostgreSQL from ROSA worker nodes
resource "aws_security_group_rule" "allow_rosa_pg" {
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  security_group_id        = aws_security_group.rds_sg.id
  # source_security_group_id = var.rosa_worker_sg_id
  self = true
}

# Egress (default allow all)
resource "aws_security_group_rule" "egress_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.rds_sg.id
}

# -----------------------------
# RDS Instance (Single-AZ)
# -----------------------------
resource "aws_db_instance" "main" {
  identifier     = var.db_identifier
  engine         = "postgres"
  engine_version = var.engine_version
  instance_class = var.instance_class

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  allocated_storage = var.allocated_storage
  storage_type      = "gp3"

  multi_az            = false
  publicly_accessible = false

  db_subnet_group_name   = aws_db_subnet_group.rds_subnet.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  backup_retention_period = var.backup_retention_period
  skip_final_snapshot     = true

  tags = {
    Name = var.db_identifier
    Role = "rds-main"
  }
}