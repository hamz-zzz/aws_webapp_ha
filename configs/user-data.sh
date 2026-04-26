#!/bin/bash
dnf update -y
dnf install -y httpd
systemctl start httpd
systemctl enable httpd

TOKEN=$(curl -s -X PUT "http://169.254.169.254/latest/api/token" \
-H "X-aws-ec2-metadata-token-ttl-seconds: 21600")

INSTANCE_ID=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/instance-id)

EC2_AVAIL_ZONE=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/placement/availability-zone)

echo "<h1>Hostname: $(hostname -f)</h1>" > /var/www/html/index.html
echo "<h1>Instance ID: $INSTANCE_ID</h1>" >> /var/www/html/index.html
echo "<h1>AZ: $EC2_AVAIL_ZONE</h1>" >> /var/www/html/index.html