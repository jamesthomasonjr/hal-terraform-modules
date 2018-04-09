# IAC Bastion
This module will create a [bastion host](https://en.wikipedia.org/wiki/Bastion_host) EC2 instance. This box should be used to connect to private hal resources to configure them.

## Configuration
| Var                            | Description
| ------------------------------ | -----------
| aws_region                     | Region where instance is created
| vpc_id                         | ID of the vpc where instance is created
| ----                           | -------
| subnet_id                      | ID of subnet to palce instance (must be a public subnet)
| allowed_ips                    | CIDR block of allowed IPs (DO NOT set this a 0.0.0.0/0)
| ssh_key_name                   | Name of ssh key pair to install on host
| ----                           | -------
|instance_type                   | Type of EC2 instance (recommend t2.micro)
| zone_name                      | Route 53 zone name

### Optional Configuartion
| Var                            | Description                  | Default
| ------------------------------ | ---------------------------- | --------
| prefix                         | prefix for resource names    | `hal`
| iac_tags                       | tags ec2 instance            | `{}`


## Output
The output values from creating your bastion host will be

| Output                         | Description
| ------------------------------ | ----------------------------
| public_ip                      | Public IP address of the host
| public_host                    | Public host address of the host
| public_dns_host                | DNS address for the host
| security_group                 | The security group id that this bastion host is in

Make note of the `security_group` ID output. You will need to use that in the `allowed_security_groups` variables of the other modules.