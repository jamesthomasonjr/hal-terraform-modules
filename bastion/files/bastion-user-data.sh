#!/bin/bash

set -e
set -x

# Send the log output from this script to user-data.log, syslog, and the console
# From: https://alestic.com/2010/12/ec2-user-data-output/
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

echo "--------------------------------------"
echo "        Installing Docker"
echo "--------------------------------------"
yum install -y docker
service docker start

echo "--------------------------------------"
echo "  Grant ec2-user Docker permissions"
echo "--------------------------------------"
usermod -a -G docker ec2-user
