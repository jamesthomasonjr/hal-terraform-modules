variable "prefix" {}
variable "vpc_id" {}
variable "name" {}

variable "subnet_ids" {
  type = "list"
}

variable "engine" {}
variable "engine_version" {}
variable "node_type" {}
variable "number_cache_nodes" {}

variable "maintenance_window" {}
variable "automatic_fail_over" {}

variable "parameter_group_name" {}

variable "port" {}

variable "allowed_security_groups" {
  type = "list"
}

variable "tags" {
  type = "map"
}
