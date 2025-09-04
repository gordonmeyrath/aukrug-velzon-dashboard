#!/bin/bash
set -euo pipefail

# Dual-remote monorepo bootstrap script
# Creates remote repos if missing and sets up dual remotes

REPO_NAME="aukrug_workspace"
FORGEJO_BASE="http://git.mioconnex.local"
FORGEJO_ORG="mioconnex"
GITHUB_OWNER="MioWorkx"
FORGEJO_SSH="git@git.mioconnex.local:mioconnex/aukrug_workspace.git"
GITHUB_SSH="git@github.com:MioWorkx/aukrug_workspace.git"

# Check required environment variables
if [[ -z "${FORGEJO_TOKEN:-}" ]] || [[ -z "${GITHUB_TOKEN:-}" ]]; then
    echo "ERROR: Missing required environment variables."
    echo "Please set: FORGEJO_TOKEN and GITHUB_TOKEN"
    echo "See .env.sample for details."
    exit 1
fi

echo "🚀 Bootstrapping dual-remote repository..."

# Function to check/create Forgejo repo
setup_forgejo_repo() {
    echo "Checking Forgejo repository..."
    
    # Check if repo exists
    if curl -s -f -H "Authorization: token $FORGEJO_TOKEN" \
        "${FORGEJO_BASE}/api/v1/repos/${FORGEJO_ORG}/${REPO_NAME}" > /dev/null 2>&1; then
        echo "✅ Forgejo repository already exists"
    else
        echo "Creating Forgejo repository..."
        curl -s -f -X POST \
            -H "Authorization: token $FORGEJO_TOKEN" \
            -H "Content-Type: application/json" \
            -d '{"name":"'$REPO_NAME'","private":true,"auto_init":false}' \
            "${FORGEJO_BASE}/api/v1/orgs/${FORGEJO_ORG}/repos" > /dev/null
        echo "✅ Forgejo repository created"
    fi
}

# Function to check/create GitHub repo
setup_github_repo() {
    echo "Checking GitHub repository..."
    
    # Check if repo exists
    if curl -s -f -H "Authorization: Bearer $GITHUB_TOKEN" \
        "https://api.github.com/repos/${GITHUB_OWNER}/${REPO_NAME}" > /dev/null 2>&1; then
        echo "✅ GitHub repository already exists"
    else
        echo "Creating GitHub repository..."
        curl -s -f -X POST \
            -H "Authorization: Bearer $GITHUB_TOKEN" \
            -H "Content-Type: application/json" \
            -d '{"name":"'$REPO_NAME'","private":true,"auto_init":false}' \
            "https://api.github.com/user/repos" > /dev/null
        echo "✅ GitHub repository created (private)"
    fi
}

# Initialize local git repo if needed
if [[ ! -d .git ]]; then
    echo "Initializing local git repository..."
    git init
    git config user.name "Aukrug Workspace"
    git config user.email "dev@mioconnex.local"
fi

# Set up remotes
echo "Setting up remotes..."
if ! git remote get-url origin > /dev/null 2>&1; then
    git remote add origin "$FORGEJO_SSH"
else
    git remote set-url origin "$FORGEJO_SSH"
fi

if ! git remote get-url backup > /dev/null 2>&1; then
    git remote add backup "$GITHUB_SSH"
else
    git remote set-url backup "$GITHUB_SSH"
fi

# Configure git settings
git config remote.pushDefault origin
git config alias.pub '!f(){ git push --all origin && git push --tags origin && git push --all backup && git push --tags backup; }; f'

# Create and setup remote repositories
setup_forgejo_repo
setup_github_repo

# Create initial commit if none exists
if ! git rev-parse HEAD > /dev/null 2>&1; then
    echo "Creating initial commit..."
    git add .
    git commit -m "Initial commit: Dual-remote monorepo scaffold"
fi

# Push to both remotes
echo "Pushing to dual remotes..."
git push -u origin main || git push -u origin master || true
git push -u backup main || git push -u backup master || true

echo ""
echo "🎉 Dual-remote repository setup complete!"
echo "   Forgejo (primary): $FORGEJO_SSH"
echo "   GitHub (backup):   $GITHUB_SSH"
echo ""
echo "Use 'git pub' to push to both remotes simultaneously."
