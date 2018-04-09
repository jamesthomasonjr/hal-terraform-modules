#!/bin/bash

set -exu

echo "--------------------------------------"
echo "        Installing Docker"
echo "--------------------------------------"
yum install -y docker
service docker start

echo "--------------------------------------"
echo "  Grant ec2-user Docker permissions"
echo "--------------------------------------"
usermod -a -G docker ec2-user