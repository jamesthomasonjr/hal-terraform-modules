data "template_file" "output" {
  template = "${file("templates/output.tpl")}"

  vars {
    rds_engine = "${module.postgres.engine} (${module.postgres.engine_version})"
    rds_url    = "${module.postgres.endpoint_fqdn}:${module.postgres.aurora_port}"
    rds_sg     = "${module.postgres.sg_id}"

    rds_username = "${module.postgres.aurora_username}"
    rds_password = "${module.postgres.aurora_password}"

    aurora_id   = "${module.postgres.aurora_id}"
    resource_id = "${module.postgres.resource_id}"

    cache_engine = "${module.redis.engine} (${module.redis.engine_version})"
    cache_url    = "${module.redis.endpoint}"
    cache_sg     = "${module.redis.sg_id}"
  }
}

output "success_message" {
  value = "${data.template_file.output.rendered}"
}
