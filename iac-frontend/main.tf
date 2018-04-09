provider "aws" {
  region = "${var.aws_region}"
}

module "beanstalk" {
  source     = "./beanstalk"
  aws_region = "${var.aws_region}"

  application_name = "${var.application_name}"
  application_id   = "${var.application_id}"
  environment_name = "${var.environment_name}"

  beanstalk_platform = "${var.beanstalk_platform}"
  beanstalk_tier     = "${var.beanstalk_tier}"
  instance_type      = "${var.instance_type}"

  healthcheck_path = "${var.healthcheck_path}"

  vpc_id                       = "${var.vpc_id}"
  subnets_private_instances    = "${var.subnets_private_instances}"
  subnets_public_load_balancer = "${var.subnets_public_load_balancer}"
  load_balancer_visibility     = "${var.load_balancer_visibility}"

  load_balancer_allowed_incoming_ip_or_sg = "${var.load_balancer_allowed_incoming_ip_or_sg}"
  dns_zone_name                           = "${var.dns_zone_name}"
}
