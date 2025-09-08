#!/bin/bash

echo "=== Setting up Backend VM ==="

# Update system
apt-get update
apt-get upgrade -y

# Install Node.js and npm
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
apt-get install -y nodejs

# Install PM2 for process management
npm install -g pm2

# Create app directory
mkdir -p /opt/todo-backend
cp -r /vagrant/backend/* /opt/todo-backend/
cd /opt/todo-backend

# Install dependencies
npm install

# Wait for database to be ready
echo "Waiting for database VM to be ready..."
while ! nc -z 192.168.56.11 3306; do
    sleep 1
done
echo "Database VM is ready!"

# Create PM2 ecosystem file
cat > ecosystem.config.js <<EOF
module.exports = {
  apps: [{
    name: 'todo-backend',
    script: 'server.js',
    env: {
      NODE_ENV: 'production',
      PORT: 3001,
      DB_HOST: '192.168.56.11',
      DB_USER: 'todouser',
      DB_PASSWORD: 'todopassword',
      DB_NAME: 'todo_app'
    }
  }]
}
EOF

# Start the application with PM2
pm2 start ecosystem.config.js
pm2 save
pm2 startup

echo "=== Backend VM setup complete ==="
echo "API accessible at: http://192.168.56.12:3001"