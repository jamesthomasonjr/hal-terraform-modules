# ----------------------------------------------------------------------------------------------------------------------
# security groups
# ----------------------------------------------------------------------------------------------------------------------

resource "aws_security_group" "database_sg" {
  name        = "${var.prefix}-aurora-sg"
  description = "SG for Hal - Database instances"
  vpc_id      = "${var.vpc_id}"

  tags = ["${var.tags}"]
}

# ----------------------------------------------------------------------------------------------------------------------
# aurora
# ----------------------------------------------------------------------------------------------------------------------

resource "aws_db_subnet_group" "default" {
  name_prefix = "${var.prefix}"
  subnet_ids  = ["${var.subnet_ids}"]

  tags = ["${var.tags}"]
}

resource "aws_rds_cluster" "aurora" {
  cluster_identifier_prefix = "${var.prefix}-pg-"

  engine         = "${var.engine}"
  engine_version = "${var.engine_version}"

  database_name = "${var.db_name}"
  port          = "${var.db_port}"

  master_username = "${var.master_username}"
  master_password = "${var.master_password}"

  backup_retention_period      = "${var.backup_retention_days}"
  preferred_backup_window      = "02:00-03:00"
  preferred_maintenance_window = "sat:05:00-sat:06:00"

  # final_snapshot_identifier = "${var.prefix}-pg-aurora-final"
  skip_final_snapshot = true

  db_subnet_group_name = "${aws_db_subnet_group.default.name}"

  # iam_database_authentication_enabled = ""
  vpc_security_group_ids = ["${aws_security_group.hal_db_sg.id}"]

  tags = ["${var.tags}"]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_rds_cluster_instance" "cluster_instances" {
  count = "${var.cluster_size}"

  engine         = "${var.engine}"
  engine_version = "${var.engine_version}"

  cluster_identifier = "${aws_rds_cluster.aurora.cluster_identifier}"
  identifier_prefix  = "${var.prefix}-pg-${count.index}"
  instance_class     = "${var.instance_type}"

  publicly_accessible  = false
  db_subnet_group_name = "${aws_db_subnet_group.default.name}"

  tags = ["${var.tags}"]
}
