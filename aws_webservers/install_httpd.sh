#!/bin/bash
yum -y update
yum -y install httpd
myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
echo "<h1>Welcome to ACS730 Week 5, Session 2! My private IP is $myip</h1>"  >  /var/www/html/index.html
sudo systemctl start httpd
sudo systemctl enable httpd