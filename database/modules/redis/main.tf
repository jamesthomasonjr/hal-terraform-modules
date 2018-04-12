# ----------------------------------------------------------------------------------------------------------------------
# security groups
# ----------------------------------------------------------------------------------------------------------------------

resource "aws_security_group" "cache_sg" {
  name        = "${var.prefix}-cache-sg"
  description = "SG for Hal - Cache instances"
  vpc_id      = "${var.vpc_id}"

  tags = ["${var.tags}"]
}

# ----------------------------------------------------------------------------------------------------------------------
# elasticache
# ----------------------------------------------------------------------------------------------------------------------

resource "aws_elasticache_subnet_group" "default" {
  name = "${var.prefix}-hal-cache-subnet-${var.name}"

  subnet_ids = ["${var.subnet_ids}"]
}

resource "aws_elasticache_replication_group" "cache" {
  replication_group_id          = "${var.prefix}-${var.name}"
  replication_group_description = "${var.prefix}-${var.name} cache group"

  engine         = "${var.engine}"
  engine_version = "${var.engine_version}"

  number_cache_clusters = "${var.cluster_size}"
  node_type             = "${var.instance_type}"
  port                  = "${var.port}"

  parameter_group_name = "${var.parameter_group_name}"

  subnet_group_name  = "${aws_elasticache_subnet_group.default.name}"
  security_group_ids = ["${aws_security_group.cache_sg.id}"]

  maintenance_window         = "${var.maintenance_window}"
  automatic_failover_enabled = "${var.automatic_fail_over}"

  tags = ["${var.tags}"]
}
