variable "tags" {
  type = "list"
}

variable "product_env_name" {}

variable "vpc_id" {}

variable "allowed_external_ips" {
  type = "list"
}

variable "bastion_sg_id" {}
variable "database_sg_id" {}
variable "cache_sg_id" {}
