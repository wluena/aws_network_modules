#!/bin/bash
yum -y update
yum -y install httpd

# CRITICAL FIX: Use command substitution to capture the IP address
mypip=$(curl http://169.254.169.254/latest/meta-data/local-ipv4)

# Start and enable the service
systemctl start httpd
systemctl enable httpd

# Use HTML to write the index.html file
cat <<EOF > /var/www/html/index.html
<html>
  <head>
    <title>Webserver Deployed by Terraform</title>
  </head>
  <body>
    <h1>Welcome to ACS730 Week 5, Session 1! My private IP is $mypip</h1>
    
    <p style="color: red;">My environment is ${env}</p>
    
  </body>
</html>
EOF