Your Elastic Beanstalk environment is created. It may take several minutes until it is ready.

DNS:
  - Route53:       ${r53_dns_name}
  - Load Balancer: ${alb_dns_name}

Elastic Beanstalk:
  - Application: ${application_name}
  - Environment: ${environment_name}

Security Groups:
 - Load Balancer: ${alb_security_group_id}
 - EC2:           ${ec2_security_group_id}

IAM:
 - Instance Profile: ${ec2_instance_profile_role_name}
