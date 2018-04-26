#!/bin/bash
sudo yum update -y
# Install ssl module
sudo yum -y install httpd mod_ssl
# Create new ssl certificate
openssl req -newkey rsa:2048 -nodes -keyout /home/ec2-user/devops.key -x509 -days 365 -out /home/ec2-user/devops.crt -subj "/C=US/ST=Wisconsin/L=Milwaukee/O=Devops/CN=www.manoj-devops-project.com"
cat > /var/www/html/index.html << 'EOL'
<html>
<head>
<title>Hello World</title>
</head>
<body>
<h1>Hello World!</h1>
</body>
</html>
EOL
cat >> /etc/httpd/conf/httpd.conf << 'EOT'
LoadModule ssl_module /etc/httpd/modules/mod_ssl.so
<VirtualHost *:443>
    ServerName www.manoj-devops-project.com
    SSLEngine on
    SSLCertificateFile /home/ec2-user/devops.crt
    SSLCertificateKeyFile /home/ec2-user/devops.key
</VirtualHost>
EOT
#Restart httpd 
service httpd restart
