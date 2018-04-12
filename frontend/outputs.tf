output "application_name" {
  value = "${module.application.name}"
}

output "environment_name" {
  value = "${module.default_environment.name}"
}

# ---------------------------------------------------------------------------------------------------------------------
# security
# ---------------------------------------------------------------------------------------------------------------------

output "instance_profile_name" {
  value = "${module.default_environment.ec2_instance_profile_role_name}"
}

# ---------------------------------------------------------------------------------------------------------------------
# dns
# ---------------------------------------------------------------------------------------------------------------------

output "alb_dns_name" {
  value = "${module.default_environment.alb_dns_name}"
}

output "route53_dns_name" {
  value = "${module.dns.hostname != "" ? module.dns.hostname : ""}"
}

# ---------------------------------------------------------------------------------------------------------------------
# security groups
# ---------------------------------------------------------------------------------------------------------------------

output "alb_security_group_id" {
  value = "${module.security_groups.load_balancer_sg}"
}

output "ec2_security_group_id" {
  value = "${module.default_environment.security_group_id}"
}
