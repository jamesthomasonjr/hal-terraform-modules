# https://registry.terraform.io/modules/terraform-aws-modules/security-group/aws/1.15.0
module "load_balancer_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "1.15.0"

  name        = "${local.product_env_name}-alb-sg"
  description = "ALB of Beanstalk - ${local.product_env_name}"
  vpc_id      = "${data.aws_vpc.vpc.id}"

  ingress_cidr_blocks = ["${var.load_balancer_allowed_incoming_ip_or_sg}"]
  ingress_rules       = ["http-80-tcp", "https-443-tcp"]
  egress_rules        = ["http-80-tcp"]

  tags = "${merge(
    var.iac_tags,
    local.default_tags,
    map("Name", "${local.product_env_name}")
  )}"
}
