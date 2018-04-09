
# IAC Database
This module will setup and data storage needed for the Hal platform. This module creates:
- Aurora DB cluster
- Elasticache setup

## Configuration
| Var                            | Description
| ------------------------------ | -----------
| aws_region                     | Region where instance is created
| vpc_id                         | ID of the vpc where instance is created
| ----                           | -------
| rds_allowed_security_groups    | List of security groups to allow access (bastion && frontend)
| rds_subnet_ids                 | Private subnet id's where aurora will place cluster instances
| rds_master_username            | Database username
| rds_master_password            | Database password
| ----                           | -------
| cache_allowed_security_groups  | List of security groups to allow access (bastion && frontend)
| cache_subnet_ids               | Private subnet id's where elasticache will place cache instances

### Optional Configuartion
| Var                            | Description                             | Default
| ------------------------------ | ----------------------------            | --------
| prefix                         | Prefix for resource names               | `hal`
| ----                           | -------                                 | --------
| rds_port                       | Port to connect to aurora               | `5432`
| rds_number_of_instances        | Number of database instances in cluster | `1`
| rds_instance_type              | Type of db instance                     | `db.r4.large`
| rds_backup_retention_days      | Number of days of db backups            | `14`
| rds_engine                     | Type of rds database                    | `aurora-postgresql`
| rds_engine_version             | Database engine version                 | `9.6.3`
| rds_tags                       | Tags for database instances             | `{}`
| ----                           | -------                                 | --------
| cache_name                     | Name of cache                           | `hal-cache`
| cache_engine                   | Type of cache                           | `redis`
| cache_engine_version           | Cache engine version                    | `3.2.10`
| cache_instance_type            | Type of cache instance                  | `cache.t2.small`
| cache_node_number              | Number of cache nodes                   | `1`
| cache_automatic_fail_over      | Cache will failover (needs 2 nodes)     | `false`
| cache_maintenance_window       | Maintenance window (possible downtime)  | `sun:05:00-sun:06:00`
| cache_parameter_group_name     | Cache options group name                | `default.redis3.2`
| cache_port                     | Port to connect to cache                | `6379`
| cache_tags                     | Tags for cache instances                | `{}`

## Notes
### Postgres Aurora
 - Aurora requires at least 2 private subnets
 - Aurora requires `rds_number_of_instances` to be greater than 1 for HA setup
#### Running migrations
The primary way to run migrations at the moment will be to open an ssh tunnel to the bastion host and have that forwarded to the
aurora cluster endpoint.
##### Get Aurora cluster endpoint
1. `cd ./non-prod/iac-databases`
2. `terragrunt output -module postgres aurora_endpoint`

Start ssh tunnel
```
ssh -i ./path/to/ec2-keypair.pem -N -L 5432:Aurora_cluster_endpoint_here:5432 ec2-my-bastion-host.amazon.aws.com
```
In a new terminal you can now connect to `localhost:5432` and that will be forwarded to the Aurora cluster.

### Elaticache Redis
 - If setting `cache_automatic_failover = true` then `cache_node_number` must be at least **2**