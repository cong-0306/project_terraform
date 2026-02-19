# -----------------------------
# DR Subnet Group
# -----------------------------
resource "aws_db_subnet_group" "dr_subnet" {
  provider   = aws.dr
  name       = "${var.dr_identifier}-subnet-group"
  subnet_ids = var.dr_subnet_ids

  tags = {
    Name = "${var.dr_identifier}-subnet-group"
    Role = "rds-dr"
  }
}

# -----------------------------
# Cross-Region Read Replica
# -----------------------------
resource "aws_db_instance" "dr_replica" {
  provider = aws.dr

  identifier = var.dr_identifier

  # 핵심 포인트
  replicate_source_db = var.source_db_instance_arn
  # source_region       = var.source_region

  instance_class      = "db.t3.micro" # DR는 보통 최소 사양
  publicly_accessible = false
  multi_az            = false

  db_subnet_group_name   = aws_db_subnet_group.dr_subnet.name
  vpc_security_group_ids = [var.dr_rds_sg_id]

  skip_final_snapshot = true

  tags = {
    Name = var.dr_identifier
    Role = "rds-dr"
  }
}