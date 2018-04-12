locals {
  rds_tags = "${merge(
    var.iac_tags,
    map("Name", "${var.prefix}-postgres")
  )}"

  cache_tags = "${merge(
    var.iac_tags,
    map("Name", "${var.prefix}-redis")
  )}"

  default_tags = {
    iac = "terraform"
  }
}

provider "aws" {
  version = "~> 1.8"
  region  = "${var.aws_region}"
}

# ----------------------------------------------------------------------------------------------------------------------
# aurora
# ----------------------------------------------------------------------------------------------------------------------

module "postgres" {
  source = "modules/postgres"

  prefix = "${var.prefix}"

  vpc_id     = "${var.vpc_id}"
  subnet_ids = ["${var.cache_subnet_ids}"]

  db_name = "${var.rds_db_name}"
  db_port = "${var.rds_port}"

  master_username = "${var.rds_master_username}"
  master_password = "${var.rds_master_password}"

  cluster_size  = "${var.rds_cluster_size}"
  instance_type = "${var.rds_instance_type}"

  engine         = "${var.rds_engine}"
  engine_version = "${var.rds_engine_version}"

  backup_retention_days = "${var.rds_backup_retention_days}"

  tags = "${merge(
    var.iac_tags,
    local.default_tags,
    local.rds_tags
  )}"
}

# ----------------------------------------------------------------------------------------------------------------------
# elasticache
# ----------------------------------------------------------------------------------------------------------------------

module "redis" {
  source = "modules/redis"

  prefix = "${var.prefix}"

  vpc_id     = "${var.vpc_id}"
  subnet_ids = ["${var.cache_subnet_ids}"]

  name = "${var.cache_name}"

  engine         = "${var.cache_engine}"
  engine_version = "${var.cache_engine_version}"

  instance_type = "${var.cache_instance_type}"
  cluster_size  = "${var.cache_cluster_size}"
  port          = "${var.cache_port}"

  parameter_group_name = "${var.cache_parameter_group_name}"

  maintenance_window   = "${var.cache_maintenance_window}"
  automatic_fail_over  = "${var.cache_automatic_fail_over}"

  tags = "${merge(
    var.iac_tags,
    local.default_tags,
    local.cache_tags
  )}"
}

# ----------------------------------------------------------------------------------------------------------------------
# bastion access to databases
# ----------------------------------------------------------------------------------------------------------------------

module "bastion_access" {
  source = "modules/bastion-access"

  bastion_security_group  = "${var.bastion_security_group}"
  # bastion_security_group  = "${data.terraform_remote_state.bastion.security_group}"
  database_security_group = "${module.postgres.sg_id}"
  cache_security_group    = "${module.postgres.sg_id}"
}
