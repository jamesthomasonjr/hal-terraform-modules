output "application_name" {
  value = "${module.application.name}"
}

output "environment_name" {
  value = "${module.default_environment.name}"
}

output "instance_profile_name" {
  value = "${module.default_environment.ec2_instance_profile_role_name}"
}

output "alb_dns_name" {
  value = "${module.default_environment.alb_dns_name}"
}

output "route53_dns_name" {
  value = "${(module.default_environment.host != "") ? module.default_environment.host : ""}"
}

output "alb_security_group_id" {
  value = "${module.default_environment_alb_sg.this_security_group_id}"
}

output "ec2_security_group_id" {
  value = "${module.default_environment.security_group_id}"
}
