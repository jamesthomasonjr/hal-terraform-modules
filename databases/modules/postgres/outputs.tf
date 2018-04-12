output "aurora_endpoint" {
  value = "${aws_rds_cluster.aurora.endpoint}"
}

output "aurora_endpoint_fqdn" {
  value = "${aws_route53_record.cluster_endpoint.fqdn}"
}

output "aurora_port" {
  value = "${aws_rds_cluster.aurora.port}"
}

output "aurora_id" {
  value = "${aws_rds_cluster.aurora.id}"
}

output "resource_id" {
  value = "${aws_rds_cluster.aurora.cluster_resource_id}"
}

output "rds_sg" {
  value = "${aws_security_group.database_sg.id}"
}

output "engine" {
  value = "${aws_rds_cluster.aurora.engine}"
}

output "engine_version" {
  value = "${aws_rds_cluster.aurora.engine_version}"
}
