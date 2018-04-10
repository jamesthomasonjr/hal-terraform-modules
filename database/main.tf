provider "aws" {
  region = "${var.aws_region}"
}

################################################################################
# Modules
################################################################################

module "postgres" {
  source = "./postgres"

  prefix                  = "${var.prefix}"
  vpc_id                  = "${var.vpc_id}"
  subnet_ids              = ["${var.rds_subnet_ids}"]
  allowed_security_groups = ["${var.rds_allowed_security_groups}"]

  master_password = "${var.rds_master_password}"
  port            = "${var.rds_port}"

  instance_type         = "${var.rds_instance_type}"
  number_of_instances   = "${var.rds_number_of_instances}"
  backup_retention_days = "${var.rds_backup_retention_days}"
  engine                = "${var.rds_engine}"
  engine_version        = "${var.rds_engine_version}"

  iac_tags = "${var.rds_tags}"
}

module "elasticache" {
  source = "./elasticache"

  prefix = "${var.prefix}"
  vpc_id = "${var.vpc_id}"

  name                    = "${var.cache_name}"
  subnet_ids              = ["${var.cache_subnet_ids}"]
  engine                  = "${var.cache_engine}"
  engine_version          = "${var.cache_engine_version}"
  node_type               = "${var.cache_instance_type}"
  number_cache_nodes      = "${var.cache_node_number}"
  maintenance_window      = "${var.cache_maintenance_window}"
  parameter_group_name    = "${var.cache_parameter_group_name}"
  port                    = "${var.cache_port}"
  allowed_security_groups = ["${var.cache_allowed_security_groups}"]
  automatic_fail_over     = "${var.cache_automatic_fail_over}"

  tags = "${var.cache_tags}"
}
