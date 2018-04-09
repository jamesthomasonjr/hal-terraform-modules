variable "aws_region" {
  description = "Region where instances get created"
}

variable "prefix" {
  description = "prefix for resource names"
  default     = "hal"
}

variable "iac_tags" {
  type    = "map"
  default = {}
}

variable "vpc_id" {}
variable "subnet_id" {}

variable "allowed_ips" {
  type = "list"
}

variable "ssh_key_name" {}
variable "instance_type" {}

variable "zone_name" {}
