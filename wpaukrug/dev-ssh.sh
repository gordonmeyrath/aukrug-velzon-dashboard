#!/usr/bin/env bash
# Quick SSH helper for Aukrug dev server
# Usage: ./dev-ssh.sh [optional extra ssh args]
set -euo pipefail
ssh devuser@10.0.1.8 "$@"
