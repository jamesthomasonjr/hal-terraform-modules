locals {
  bastion_tags = "${merge(
    var.iac_tags,
    map("Name", "${var.prefix}-bastion")
  )}"

  volume_tags = "${merge(
    var.iac_tags,
    map("Name", "${var.prefix}-bastion")
  )}"
}

# Configure the AWS Provider
provider "aws" {
  version = "~> 1.8"
  region  = "${var.aws_region}"
}

data "aws_ami" "bastion_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn-ami-hvm-*-x86_64-gp2"]
  }
}

data "aws_route53_zone" "hosted_zone" {
  name = "${var.zone_name}"
}

resource "aws_instance" "bastion" {
  instance_type = "${var.instance_type}"
  ami           = "${data.aws_ami.bastion_ami.id}"
  key_name      = "${var.ssh_key_name}"
  subnet_id     = "${var.subnet_id}"

  associate_public_ip_address = "1"
  disable_api_termination     = "0"

  vpc_security_group_ids = ["${aws_security_group.bastion_sg.id}"]

  user_data = "${file("${path.module}/files/bastion-user-data.sh")}"

  tags        = "${local.bastion_tags}"
  volume_tags = "${local.volume_tags}"

  lifecycle {
    prevent_destroy = false
  }
}

################################################################################
# Security group
################################################################################

resource "aws_security_group" "bastion_sg" {
  name        = "${var.prefix}-bastion-sg"
  description = "SG for Hal- For bastion of Hal environment"
  vpc_id      = "${var.vpc_id}"

  tags = "${merge(var.iac_tags, local.bastion_tags)}"
}

resource "aws_security_group_rule" "bastion_ssh_ingress" {
  type      = "ingress"
  protocol  = "tcp"
  from_port = 22
  to_port   = 22

  cidr_blocks       = "${var.allowed_ips}"
  security_group_id = "${aws_security_group.bastion_sg.id}"
}

resource "aws_security_group_rule" "bastion_sg_egress" {
  type      = "egress"
  protocol  = "-1"
  from_port = 0
  to_port   = 0

  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.bastion_sg.id}"
}

################################################################################
# Security group
################################################################################

resource "aws_route53_record" "default" {
  count   = 1
  zone_id = "${data.aws_route53_zone.hosted_zone.zone_id}"
  name    = "${var.prefix}-bastion"

  type    = "A"
  ttl     = "120"
  records = ["${aws_instance.bastion.public_ip}"]
}
