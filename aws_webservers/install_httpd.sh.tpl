#!/bin/bash

private_ip=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)

# Update and install Apache
yum update -y
yum install -y httpd

# Start and enable the service
systemctl start httpd
systemctl enable httpd

# Create dynamic index.html using template variable and shell variable
echo "Welcome to ${message}! My private IP is $private_ip" > /var/www/html/index.html