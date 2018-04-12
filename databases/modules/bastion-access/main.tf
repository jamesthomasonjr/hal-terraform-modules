# ----------------------------------------------------------------------------------------------------------------------
# local vars
# ----------------------------------------------------------------------------------------------------------------------

data "aws_security_group" "bastion" {
  id = "${var.bastion_security_group}"
}

data "aws_security_group" "database" {
  id = "${var.database_security_group}"
}

data "aws_security_group" "cache" {
  id = "${var.cache_security_group}"
}

# ----------------------------------------------------------------------------------------------------------------------
# bastion -> database
# ----------------------------------------------------------------------------------------------------------------------

resource "aws_security_group_rule" "bastion_to_postgres_5432" {
  type      = "ingress"
  protocol  = "tcp"
  from_port = 5432
  to_port   = 5432

  source_security_group_id = "${data.aws_security_group.bastion.id}"
  security_group_id        = "${data.aws_security_group.database.id}"
}

# ----------------------------------------------------------------------------------------------------------------------
# bastion -> cache
# ----------------------------------------------------------------------------------------------------------------------

resource "aws_security_group_rule" "bastion_to_redis_6379" {
  type      = "ingress"
  protocol  = "tcp"
  from_port = 6379
  to_port   = 6379

  source_security_group_id = "${data.aws_security_group.bastion.id}"
  security_group_id        = "${data.aws_security_group.cache.id}"
}
