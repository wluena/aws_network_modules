#!/bin/bash

# Update and install Apache
yum update -y
yum install -y httpd

# Start and enable the service
systemctl start httpd
systemctl enable httpd

# Create dynamic index.html using variables passed from Terraform
echo "Welcome to ${message}! My private IP is ${private_ip}" > /var/www/html/index.html
echo "Built by Terraform!" >> /var/www/html/index.html
