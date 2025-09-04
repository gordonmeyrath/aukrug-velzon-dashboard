#!/bin/bash

# Developer Quality-of-Life aliases for aukrug_workspace
# Source this file: source tool/scripts/dev-aliases.sh

# Git shortcuts with function syntax
alias gci='f(){ git add -A && git commit -m "$*"; }; f'
alias gpub='git pub'  # Push to both remotes (origin + backup)

# Project shortcuts
alias app-build='cd app && flutter pub get && dart run build_runner build --delete-conflicting-outputs && cd ..'
alias app-test='cd app && flutter test && cd ..'
alias app-analyze='cd app && flutter analyze && cd ..'

alias plugin-lint='cd plugin && composer install --quiet && vendor/bin/phpcs --standard=PSR12 . && cd ..'
alias plugin-test='cd plugin && composer install --quiet && vendor/bin/phpunit && cd ..'

# Workspace shortcuts
alias workspace-backup='bash tool/backup.sh'
alias workspace-status='echo "📱 App:" && cd app && flutter --version | head -1 && cd .. && echo "🔌 Plugin:" && cd plugin && php --version | head -1 && cd ..'

echo "🔧 Aukrug workspace aliases loaded!"
echo "Available commands:"
echo "  gci '<msg>'   - Quick commit with message"
echo "  gpub          - Push to both remotes"
echo "  app-build     - Build Flutter app with code generation"
echo "  app-test      - Run Flutter tests"
echo "  app-analyze   - Run Flutter analysis"
echo "  plugin-lint   - Run PHP CodeSniffer"
echo "  plugin-test   - Run PHPUnit tests"
echo "  workspace-*   - Backup and status commands"
