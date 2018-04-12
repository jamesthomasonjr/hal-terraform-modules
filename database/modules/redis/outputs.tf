output "endpoint" {
  value = "${aws_elasticache_replication_group.cache.primary_endpoint_address}"
}

output "sg_id" {
  value = "${aws_security_group.cache_sg.id}"
}

output "engine" {
  value = "${aws_security_group.cache.engine}"
}

output "engine_version" {
  value = "${aws_security_group.cache.engine_version}"
}
