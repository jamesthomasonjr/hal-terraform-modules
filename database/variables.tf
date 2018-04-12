variable "aws_region" {
  description = "Region where instances get created"
}

variable "prefix" {
  description = "prefix for resource names"
  default     = "hal"
}

variable "vpc_id" {}

# rds

# Aurora requires at least 2 subnets
variable "rds_subnet_ids" {
  type = "list"
}

variable "rds_db_name" {
  default = "hal"
}

variable "rds_port" {
  default = "5432"
}

variable "rds_master_username" {}
variable "rds_master_password" {}

variable "rds_instance_type" {
  default = "db.r4.large"
}

variable "rds_cluster_size" {
  default = "1"
}

variable "rds_backup_retention_days" {
  default = 14
}

variable "rds_engine" {
  default = "aurora-postgresql"
}

variable "rds_engine_version" {
  default = "9.6.3"
}

variable "rds_tags" {
  type    = "map"
  default = {}
}

# elasticache
variable "cache_name" {
  default = "hal-cache"
}

variable "cache_subnet_ids" {
  type = "list"
}

variable "cache_engine" {
  default = "redis"
}

variable "cache_engine_version" {
  default = "3.2.10"
}

# if this is true "cache_node_number" has to be 2 or larger
variable "cache_automatic_fail_over" {
  default = false
}

variable "cache_maintenance_window" {
  # SUN 01:00AM-02:00AM ET
  default = "sun:05:00-sun:06:00"
}

variable "cache_parameter_group_name" {
  default = "default.redis3.2"
}

variable "cache_instance_type" {
  default = "cache.t2.small"
}

variable "cache_cluster_size" {
  default = "1"
}

variable "cache_port" {
  default = "6379"
}

variable "cache_tags" {
  type    = "map"
  default = {}
}
