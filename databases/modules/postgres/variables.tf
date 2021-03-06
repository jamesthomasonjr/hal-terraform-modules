variable "prefix" {}

variable "tags" {
  type    = "map"
  default = {}
}

# ----------------------------------------------------------------------------------------------------------------------
# networking
# ----------------------------------------------------------------------------------------------------------------------

variable "vpc_id" {}

variable "subnet_ids" {
  type = "list"
}

# ----------------------------------------------------------------------------------------------------------------------
# security
# ----------------------------------------------------------------------------------------------------------------------

variable "master_username" {}
variable "master_password" {}

# ----------------------------------------------------------------------------------------------------------------------
# instances
# ----------------------------------------------------------------------------------------------------------------------

variable "cluster_size" {}
variable "instance_type" {}

# ----------------------------------------------------------------------------------------------------------------------
# configuration
# ----------------------------------------------------------------------------------------------------------------------

variable "db_name" {}
variable "db_port" {}

variable "backup_retention_days" {}

# ----------------------------------------------------------------------------------------------------------------------
# version
# ----------------------------------------------------------------------------------------------------------------------

variable "engine" {}
variable "engine_version" {}
