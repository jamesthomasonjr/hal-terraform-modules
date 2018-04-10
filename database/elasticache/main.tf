resource "aws_security_group" "hal_cache_security" {
  vpc_id      = "${var.vpc_id}"
  description = "SG for ${var.prefix}-${var.name}  Cache instances"

  ingress {
    from_port       = "${var.port}"
    to_port         = "${var.port}"
    protocol        = "tcp"
    security_groups = ["${var.allowed_security_groups}"]
  }
}

resource "aws_elasticache_subnet_group" "hal_cache_subnet" {
  name        = "${var.prefix}-hal-cache-subnet-${var.name}"
  description = "Private subnets for the ElastiCache instances: ${var.prefix}-${var.name}"

  subnet_ids = ["${var.subnet_ids}"]
}

resource "aws_elasticache_replication_group" "hal_cache" {
  engine                        = "${var.engine}"
  engine_version                = "${var.engine_version}"
  replication_group_id          = "${var.prefix}-${var.name}"
  replication_group_description = "${var.prefix}-${var.name} cache group"
  node_type                     = "${var.node_type}"
  number_cache_clusters         = "${var.number_cache_nodes}"
  parameter_group_name          = "${var.parameter_group_name}"
  port                          = "${var.port}"

  subnet_group_name  = "${aws_elasticache_subnet_group.hal_cache_subnet.name}"
  security_group_ids = ["${aws_security_group.hal_cache_security.id}"]

  automatic_failover_enabled = "${var.automatic_fail_over}"
  maintenance_window         = "${var.maintenance_window}"

  tags = "${var.tags}"
}
