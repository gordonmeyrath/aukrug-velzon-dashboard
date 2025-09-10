#!/bin/bash

# Aukrug Dashboard Deployment Script
# Builds and deploys Next.js dashboard to remote LXC container
# Usage: ./remote_deploy.sh [host] [village_name]

set -euo pipefail

HOST="${1:-root@10.0.1.12}"
VILLAGE="${2:-appmin}"
LOCAL_BUILD_DIR="../.next"
REMOTE_DIR="/opt/aukrug-dashboard"

echo "=== Aukrug Dashboard Deployment Started ==="
echo "Host: $HOST"
echo "Village: $VILLAGE"
echo "Timestamp: $(date)"

# Ensure we're in the dashboard directory
cd "$(dirname "$0")/../.."

# Build dashboard locally
echo "=== Building dashboard locally ==="
if [ ! -f "package.json" ]; then
    echo "Error: No package.json found. Please run from dashboard directory."
    exit 1
fi

# Install dependencies
echo "Installing dependencies..."
pnpm install

# Build for production
echo "Building for production..."
pnpm build

# Check build output
if [ ! -d ".next" ]; then
    echo "Error: Build failed - no .next directory found"
    exit 1
fi

# Create deployment package
echo "=== Creating deployment package ==="
rm -rf dist/
mkdir -p dist/

# Copy Next.js standalone build
cp -r .next/standalone/* dist/
cp -r .next/static dist/.next/static
cp -r public dist/public

# Copy package.json for production dependencies
cp package.json dist/

echo "=== Deploying to remote server ==="

# Stop service before deployment
ssh $HOST "systemctl stop aukrug-dashboard || true"

# Backup existing deployment
ssh $HOST "
    if [ -d $REMOTE_DIR ]; then
        mv $REMOTE_DIR $REMOTE_DIR.backup.\$(date +%Y%m%d_%H%M%S)
    fi
    mkdir -p $REMOTE_DIR
"

# Upload build artifacts
echo "Uploading build artifacts..."
rsync -avz --delete dist/ $HOST:$REMOTE_DIR/

# Install production dependencies on remote
echo "Installing production dependencies on remote..."
ssh $HOST "
    cd $REMOTE_DIR
    export PATH=\"/root/.local/share/pnpm:\$PATH\"
    pnpm install --prod --frozen-lockfile
"

# Set proper permissions
ssh $HOST "
    chown -R root:root $REMOTE_DIR
    chmod +x $REMOTE_DIR/server.js
"

# Start service
echo "=== Starting dashboard service ==="
ssh $HOST "
    systemctl start aukrug-dashboard
    systemctl status aukrug-dashboard --no-pager
"

# Reload nginx
ssh $HOST "nginx -t && systemctl reload nginx"

echo "=== Deployment completed successfully ==="
echo ""
echo "Dashboard should be available at:"
ssh $HOST "source /etc/aukrug-dashboard.env && echo \"\$DASHBOARD_BASE_URL\""

# Cleanup local build artifacts
rm -rf dist/

echo "=== Deployment finished ==="
