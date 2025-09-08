#!/bin/bash

echo "=== Setting up Database VM ==="

# Update system
apt-get update
apt-get upgrade -y

# Install MySQL Server
debconf-set-selections <<< 'mysql-server mysql-server/root_password password rootpassword'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password rootpassword'
apt-get install -y mysql-server

# Configure MySQL for remote connections
sed -i 's/bind-address.*= 127.0.0.1/bind-address = 0.0.0.0/' /etc/mysql/mysql.conf.d/mysqld.cnf

# Restart MySQL
systemctl restart mysql
systemctl enable mysql

# Create database and user
mysql -u root -prootpassword <<EOF
CREATE DATABASE IF NOT EXISTS todo_app;
CREATE USER 'todouser'@'%' IDENTIFIED BY 'todopassword';
GRANT ALL PRIVILEGES ON todo_app.* TO 'todouser'@'%';
FLUSH PRIVILEGES;
EOF

# Import schema and sample data
if [ -f /vagrant/database/schema.sql ]; then
    mysql -u root -prootpassword todo_app < /vagrant/database/schema.sql
    echo "Database schema imported"
fi

if [ -f /vagrant/database/sample-data.sql ]; then
    mysql -u root -prootpassword todo_app < /vagrant/database/sample-data.sql
    echo "Sample data imported"
fi

echo "=== Database VM setup complete ==="
echo "MySQL accessible at: 192.168.56.11:3306"
echo "Database: todo_app"
echo "User: todouser"
echo "Password: todopassword"