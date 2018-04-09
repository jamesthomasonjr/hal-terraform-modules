output "redis_primary_endpoint" {
  value = "${aws_elasticache_replication_group.hal_cache.primary_endpoint_address}"
}
