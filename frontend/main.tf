# ----------------------------------------------------------------------------------------------------------------------
# local vars
# ----------------------------------------------------------------------------------------------------------------------

locals {
  product_name     = "${var.application_name}-${var.application_id}"
  product_env_name = "${var.application_name}-${var.application_id}-${var.environment_name}"

  # https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/concepts.platforms.html
  available_stack_regex = {
    "docker"        = "^64bit Amazon Linux (.*) Docker 17.09.1-ce$"
    "docker-esc"    = "^64bit Amazon Linux (.*) Multi-container Docker 17.09.1-ce (Generic)$"
    "dotnet"        = "^64bit Windows Server 2016 (.*) IIS 10.0$"
    "dotnet-wsc"    = "^64bit Windows Server Core 2016 (.*) IIS 10.0$"
    "go1.9"         = "^64bit Amazon Linux (.*) Go 1.9$"
    "java8"         = "^64bit Amazon Linux (.*) Java 8$"
    "java8-tomcat8" = "^64bit Amazon Linux (.*) Tomcat 8 Java 8$"
    "nodejs"        = "^64bit Amazon Linux (.*) Node.js$"
    "php5.6"        = "^64bit Amazon Linux (.*) PHP 5.6$"
    "php7.0"        = "^64bit Amazon Linux (.*) PHP 7.0$"
    "php7.1"        = "^64bit Amazon Linux (.*) PHP 7.1$"
    "python3.6"     = "^64bit Amazon Linux (.*) Python 3.6$"
    "python2.7"     = "^64bit Amazon Linux (.*) Python 2.7$"
  }

  solution_stack_name = "${(var.custom_beanstalk_platform != "") ? var.custom_beanstalk_platform : lookup(local.available_stack_regex, var.beanstalk_platform)}"

  default_tags = {
    iac = "terraform"
  }
}

provider "aws" {
  region = "${var.aws_region}"
}

data "aws_elastic_beanstalk_solution_stack" "target_stack" {
  most_recent = true
  name_regex  = "${local.solution_stack_name}"
}

data "aws_vpc" "vpc" {
  id = "${var.vpc_id}"
}

# ----------------------------------------------------------------------------------------------------------------------
# security groups (for application instances)
# ----------------------------------------------------------------------------------------------------------------------

module "security_groups" {
  source  = "modules/security-groups"

  product_env_name = "${local.product_env_name}"
  vpc_id           = "${data.aws_vpc.vpc.id}"

  allowed_external_ips = ["${var.allowed_external_ips}"]

  bastion_sg_id  = "${var.bastion_security_group}"
  database_sg_id  = "${var.database_security_group}"
  cache_sg_id  = "${var.cache_security_group}"

  tags = ["${var.iac_tags}"]
}

# ----------------------------------------------------------------------------------------------------------------------
# elastic beanstalk
# ----------------------------------------------------------------------------------------------------------------------

module "application" {
  source = "modules/beanstalk-application"
  name   = "${local.product_name}"
}

module "default_environment" {
  source = "modules/beanstalk-environment"

  # beanstalk
  beanstalk_application = "${module.application.name}"
  name                  = "${local.product_name}"
  stage                 = "${var.environment_name}"
  tier                  = "${lookup(var.available_tiers, var.beanstalk_tier)}"

  ssh_keypair_name    = "${var.ssh_keypair_name}"
  solution_stack_name = "${data.aws_elastic_beanstalk_solution_stack.target_stack.name}"
  instance_type       = "${var.instance_type}"

  # load balancing
  healthcheck_path                  = "${var.healthcheck_path}"
  load_balancer_ssl_certificate_arn = "${var.ssl_certificate_arn}"
  alb_sg                            = "${module.security_groups.this_security_group_id}"
  alb_additional_security_groups    = ["${var.load_balancer_additional_sg}"]
  http_listener_enabled             = true

  # rolling updates
  deploying_policy  = "${var.deploying_policy}"
  batch_update_size = "${var.rolling_update_max_batch_size}"

  # auto scaling
  autoscale_min         = "${var.asg_min_instances}"
  autoscale_max         = "${var.asg_max_instances}"
  autoscale_lower_bound = "${var.asg_trigger_lower_threshold}"
  autoscale_upper_bound = "${var.asg_trigger_higher_threshold}"

  # network
  vpc_id                   = "${data.aws_vpc.vpc.id}"
  instance_subnets         = ["${var.subnets_private_instances}"]
  load_balancer_subnets    = ["${var.subnets_public_load_balancer}"]
  load_balancer_visibility = "${var.load_balancer_visibility}"

  iac_tags = "${merge(
    var.iac_tags,
    local.default_tags
  )}"
}

# ----------------------------------------------------------------------------------------------------------------------
# dns
# ----------------------------------------------------------------------------------------------------------------------

module "dns" {
  source = "modules/route53"

  enabled   = "${var.dns_zone_name != "" ? "true" : "false"}"
  zone_name = "${var.dns_zone_name}"
  name      = "${local.product_env_name}"
  records   = ["${module.default_environment.alb_dns_name}"]
}

