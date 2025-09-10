#!/bin/bash

# Aukrug LXC Provisioning Script
# Provisions WordPress + Next.js Dashboard on single container
# Usage: ./remote_provision.sh [village_name] [domain]

set -euo pipefail

VILLAGE="${1:-appmin}"
DOMAIN="${2:-${VILLAGE}.miocitynet.com}"
DB_ROOT_PASS="$(openssl rand -base64 32)"
WP_DB_NAME="aukrug_wp"
WP_DB_USER="aukrug_wp_user"
WP_DB_PASS="$(openssl rand -base64 32)"

echo "=== Aukrug LXC Provisioning Started ==="
echo "Village: $VILLAGE"
echo "Domain: $DOMAIN"
echo "Timestamp: $(date)"

# Update system
echo "=== Updating system packages ==="
apt-get update -y
apt-get upgrade -y

# Install base packages
echo "=== Installing base packages ==="
apt-get install -y \
    curl \
    git \
    build-essential \
    software-properties-common \
    gnupg2 \
    wget \
    unzip \
    ufw \
    certbot \
    python3-certbot-nginx

# Install Node.js 20 LTS
echo "=== Installing Node.js 20 LTS ==="
curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
apt-get install -y nodejs

# Install pnpm
echo "=== Installing pnpm ==="
curl -fsSL https://get.pnpm.io/install.sh | sh -
export PATH="$HOME/.local/share/pnpm:$PATH"
echo 'export PATH="$HOME/.local/share/pnpm:$PATH"' >> /root/.bashrc

# Install PM2 globally
echo "=== Installing PM2 ==="
npm install -g pm2

# Install Nginx
echo "=== Installing Nginx ==="
apt-get install -y nginx

# Install PHP 8.2 and extensions
echo "=== Installing PHP 8.2 ==="
# Install from Debian repositories first, then sury.org for latest
apt-get install -y php8.2-fpm php8.2-mysql php8.2-xml php8.2-mbstring php8.2-curl php8.2-gd php8.2-intl php8.2-soap php8.2-zip php8.2-bcmath php8.2-cli php8.2-common php8.2-opcache 2>/dev/null || {
    echo "Installing from sury.org repository..."
    curl -sSL https://packages.sury.org/php/apt.gpg | apt-key add -
    echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/sury-php.list
    apt-get update -qq
    apt-get install -y php8.2-fpm php8.2-mysql php8.2-xml php8.2-mbstring php8.2-curl php8.2-gd php8.2-intl php8.2-soap php8.2-zip php8.2-bcmath php8.2-cli php8.2-common php8.2-opcache
}

# Install MariaDB
echo "=== Installing MariaDB ==="
apt-get install -y mariadb-server mariadb-client

# Configure MariaDB
echo "=== Configuring MariaDB ==="
systemctl start mariadb
systemctl enable mariadb

# Secure MariaDB installation
mysql <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '$DB_ROOT_PASS';
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
FLUSH PRIVILEGES;
EOF
CREATE DATABASE $WP_DB_NAME CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER '$WP_DB_USER'@'localhost' IDENTIFIED BY '$WP_DB_PASS';
GRANT ALL PRIVILEGES ON $WP_DB_NAME.* TO '$WP_DB_USER'@'localhost';
FLUSH PRIVILEGES;
EOF

echo "MariaDB root password: $DB_ROOT_PASS" > /root/aukrug-db-credentials.txt
echo "WordPress DB user: $WP_DB_USER" >> /root/aukrug-db-credentials.txt
echo "WordPress DB password: $WP_DB_PASS" >> /root/aukrug-db-credentials.txt
chmod 600 /root/aukrug-db-credentials.txt

# Download and install WordPress
echo "=== Installing WordPress ==="
mkdir -p /var/www
cd /var/www
wget https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz
rm latest.tar.gz
chown -R www-data:www-data /var/www/wordpress
chmod -R 755 /var/www/wordpress

# Configure WordPress
echo "=== Configuring WordPress ==="
cd /var/www/wordpress
cp wp-config-sample.php wp-config.php

# Update wp-config.php with database credentials
sed -i "s/database_name_here/$WP_DB_NAME/" wp-config.php
sed -i "s/username_here/$WP_DB_USER/" wp-config.php
sed -i "s/password_here/$WP_DB_PASS/" wp-config.php

# Generate WordPress salt keys
SALT_KEYS=$(curl -s https://api.wordpress.org/secret-key/1.1/salt/)
sed -i "/AUTH_KEY/,/NONCE_SALT/d" wp-config.php
sed -i "/table_prefix/i\\$SALT_KEYS" wp-config.php

# Create Nginx configuration
echo "=== Configuring Nginx ==="
cat > /etc/nginx/sites-available/aukrug-$VILLAGE <<EOF
server {
    listen 80;
    server_name $DOMAIN;
    
    # Redirect HTTP to HTTPS
    return 301 https://\$server_name\$request_uri;
}

server {
    listen 443 ssl http2;
    server_name $DOMAIN;

    # SSL Configuration (will be updated by certbot)
    ssl_certificate /etc/ssl/certs/ssl-cert-snakeoil.pem;
    ssl_certificate_key /etc/ssl/private/ssl-cert-snakeoil.key;
    
    # Security headers
    add_header X-Frame-Options DENY;
    add_header X-Content-Type-Options nosniff;
    add_header X-XSS-Protection "1; mode=block";
    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains";

    # Root redirect to /cms/
    location = / {
        return 301 https://\$server_name/cms/;
    }

    # WordPress at /cms/
    location /cms/ {
        alias /var/www/wordpress/;
        index index.php index.html index.htm;
        
        try_files \$uri \$uri/ /cms/index.php?\$args;
        
        location ~ /cms/.*\\.php\$ {
            alias /var/www/wordpress/;
            fastcgi_pass unix:/run/php/php8.2-fpm.sock;
            fastcgi_index index.php;
            fastcgi_param SCRIPT_FILENAME \$request_filename;
            include fastcgi_params;
            
            # WordPress specific
            fastcgi_param REQUEST_URI \$uri;
            fastcgi_param SCRIPT_NAME /cms/index.php;
        }
    }

    # Dashboard at /dashboard/
    location /dashboard/ {
        proxy_pass http://localhost:3000/dashboard/;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_cache_bypass \$http_upgrade;
    }

    # Static files for dashboard
    location /dashboard/_next/static/ {
        proxy_pass http://localhost:3000/dashboard/_next/static/;
        expires 365d;
        add_header Cache-Control "public, immutable";
    }
}
EOF

# Enable site
ln -sf /etc/nginx/sites-available/aukrug-$VILLAGE /etc/nginx/sites-enabled/
rm -f /etc/nginx/sites-enabled/default

# Test nginx configuration
nginx -t

# Create dashboard directory
echo "=== Setting up dashboard directory ==="
mkdir -p /opt/aukrug-dashboard

# Create environment file
echo "=== Creating environment configuration ==="
cat > /etc/aukrug-dashboard.env <<EOF
DOMAIN=$DOMAIN
DASHBOARD_BASE_URL=https://$DOMAIN/dashboard
WP_BASE_URL=https://$DOMAIN/cms
TENANT_NAME=$(echo $VILLAGE | sed 's/^./\U&/' | sed 's/[^a-zA-Z].*/&/')
VILLAGE_NAME=$VILLAGE
EOF

# Create systemd service for dashboard
echo "=== Creating systemd service ==="
cat > /etc/systemd/system/aukrug-dashboard.service <<EOF
[Unit]
Description=Aukrug Dashboard ($VILLAGE)
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/opt/aukrug-dashboard
EnvironmentFile=/etc/aukrug-dashboard.env
ExecStart=/usr/bin/node server.js
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable aukrug-dashboard

# Configure firewall
echo "=== Configuring firewall ==="
ufw allow 22/tcp
ufw allow 80/tcp
ufw allow 443/tcp
ufw --force enable

# Start services
echo "=== Starting services ==="
systemctl enable nginx php8.2-fpm mariadb
systemctl start nginx php8.2-fpm mariadb

# Obtain SSL certificate
echo "=== Obtaining SSL certificate ==="
certbot --nginx -d $DOMAIN --non-interactive --agree-tos --email admin@$DOMAIN || echo "SSL setup will be completed manually"

echo "=== Provisioning completed successfully ==="
echo ""
echo "Next steps:"
echo "1. Deploy dashboard with: make dashboard-deploy"
echo "2. Access WordPress at: https://$DOMAIN/cms/"
echo "3. Access Dashboard at: https://$DOMAIN/dashboard/"
echo ""
echo "Database credentials stored in: /root/aukrug-db-credentials.txt"
echo "Environment config: /etc/aukrug-dashboard.env"
