#!/bin/bash

echo "=== Setting up Frontend VM ==="

# Update system
apt-get update
apt-get upgrade -y

# Install Node.js for building React app
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
apt-get install -y nodejs

# Install Nginx
apt-get install -y nginx

# Build React application
cd /vagrant/frontend
npm install
REACT_APP_API_URL=http://192.168.56.12:3001/api npm run build

# Configure Nginx
cat > /etc/nginx/sites-available/default <<EOF
server {
    listen 80;
    server_name localhost;
    root /var/www/html/todo-app;
    index index.html;

    # Frontend routes
    location / {
        try_files \$uri \$uri/ /index.html;
    }

    # Proxy API requests to backend VM
    location /api {
        proxy_pass http://192.168.56.12:3001;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    }

    # Health check
    location /health {
        access_log off;
        return 200 "healthy\\n";
        add_header Content-Type text/plain;
    }
}
EOF

# Copy built files to web root
mkdir -p /var/www/html/todo-app
cp -r /vagrant/frontend/build/* /var/www/html/todo-app/

# Start Nginx
systemctl restart nginx
systemctl enable nginx

echo "=== Frontend VM setup complete ==="
echo "Web application accessible at: http://localhost:8080"
echo "Or directly at: http://192.168.56.13"