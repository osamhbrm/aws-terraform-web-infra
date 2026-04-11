#!/bin/bash
yum update -y
yum install -y httpd mariadb105 jq
SECRET_NAME="web-app-db-secret"
REGION="us-east-1"

# جلب بيانات قاعدة البيانات
DB_DATA=$(aws secretsmanager get-secret-value --secret-id $SECRET_NAME --region $REGION --query SecretString --output text)

DB_USER=$(echo $DB_DATA | jq -r .username)
DB_PASS=$(echo $DB_DATA | jq -r .password)
DB_HOST=$(echo $DB_DATA | jq -r .host)
DB_NAME=$(echo $DB_DATA | jq -r .db_name)

systemctl start httpd
systemctl enable httpd

echo "<h1>Hello from Osamh's Private Web Server</h1><p>Server Hostname: $(hostname -f)</p>" > /var/www/html/index.html
echo "<p>Connected to Host: $DB_HOST</p>" >> /var/www/html/index.html

if mysqladmin -h $DB_HOST -u $DB_USER -p$DB_PASS ping > /dev/null 2>&1; then
    echo "<h2 style='color:green;'>DB Connection: SUCCESS</h2>" >> /var/www/html/index.html
else
    echo "<h2 style='color:red;'>DB Connection: FAILED</h2>" >> /var/www/html/index.html
fi