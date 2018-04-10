variable "prefix" {}

variable "vpc_id" {}

variable "subnet_ids" {
  type = "list"
}

variable "instance_type" {}
variable "number_of_instances" {}

variable "backup_retention_days" {}

variable "engine" {}
variable "engine_version" {}

variable "master_password" {}
variable "port" {}

variable "allowed_security_groups" {
  type = "list"
}

variable "iac_tags" {
  type    = "map"
  default = {}
}
