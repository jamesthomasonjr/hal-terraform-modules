variable "aws_region" {
  description = "Region where instances get created"
}

variable "prefix" {
  description = "Prefix for resource names"
  default     = "hal"
}

variable "iac_tags" {
  type    = "map"
  default = {}
}

# ---------------------------------------------------------------------------------------------------------------------
# networking
# ---------------------------------------------------------------------------------------------------------------------

variable "vpc_id" {}
variable "subnet_id" {}

variable "allowed_ips" {
  type = "list"
}

variable "zone_name" {
  description = "[Optional] Enter zone name to create Route53 DNS record"
  default = ""
}

# ---------------------------------------------------------------------------------------------------------------------
# instance
# ---------------------------------------------------------------------------------------------------------------------

variable "ssh_key_name" {}
variable "instance_type" {}
