#!/bin/bash
set -euo pipefail

# Backup script for aukrug_workspace
# Creates timestamped zip archive excluding build artifacts

echo "🗂️  Creating backup archive..."

# Get commit hash and timestamp
COMMIT_HASH=$(git rev-parse --short HEAD 2>/dev/null || echo "no-git")
TIMESTAMP=$(date -u +"%Y%m%d_%H%M%S")
BACKUP_NAME="aukrug_workspace_${COMMIT_HASH}_${TIMESTAMP}.zip"

# Ensure backups directory exists
mkdir -p backups

# Create zip excluding build artifacts and version control
zip -r "backups/${BACKUP_NAME}" . \
    -x "*.git*" \
    -x "**/build/**" \
    -x "**/node_modules/**" \
    -x "**/vendor/**" \
    -x "**/.dart_tool/**" \
    -x "**/coverage/**" \
    -x "**/.flutter-plugins*" \
    -x "**/.packages" \
    -x "**/pubspec.lock" \
    -x "**/.env" \
    -x "**/.DS_Store" \
    -x "backups/*.zip"

echo "✅ Backup created: backups/${BACKUP_NAME}"
ls -lh "backups/${BACKUP_NAME}"
