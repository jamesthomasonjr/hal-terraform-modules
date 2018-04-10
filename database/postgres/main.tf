resource "aws_security_group" "hal_db_sg" {
  name        = "${var.prefix}-aurora-sg"
  description = "SG for Hal - Database instances"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port       = "${var.port}"
    to_port         = "${var.port}"
    protocol        = "tcp"
    description     = "Allow access to hal db on port ${var.port}"
    security_groups = ["${var.allowed_security_groups}"]
  }

  tags = "${var.iac_tags}"
}

resource "aws_db_subnet_group" "default" {
  name_prefix = "${var.prefix}"
  subnet_ids  = ["${var.subnet_ids}"]

  tags = "${var.iac_tags}"
}

resource "aws_rds_cluster" "aurora" {
  cluster_identifier_prefix = "${var.prefix}-pg"

  engine         = "${var.engine}"
  engine_version = "${var.engine_version}"

  database_name   = "hal"
  master_username = "hal"
  master_password = "${var.master_password}"
  port            = "${var.port}"

  backup_retention_period      = "${var.backup_retention_days}"
  preferred_backup_window      = "02:00-03:00"
  preferred_maintenance_window = "sat:05:00-sat:06:00"

  # final_snapshot_identifier = "${var.prefix}-pg-aurora-final"
  skip_final_snapshot = true

  db_subnet_group_name = "${aws_db_subnet_group.default.name}"

  # iam_database_authentication_enabled = ""
  vpc_security_group_ids = ["${aws_security_group.hal_db_sg.id}"]

  tags = "${var.iac_tags}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_rds_cluster_instance" "cluster_instances" {
  count = "${var.number_of_instances}"

  engine         = "${var.engine}"
  engine_version = "${var.engine_version}"

  cluster_identifier = "${aws_rds_cluster.aurora.cluster_identifier}"
  identifier_prefix  = "${var.prefix}-pg-${count.index}"
  instance_class     = "${var.instance_type}"

  publicly_accessible  = false
  db_subnet_group_name = "${aws_db_subnet_group.default.name}"

  tags = "${var.iac_tags}"
}
