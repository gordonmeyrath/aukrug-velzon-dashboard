#!/usr/bin/env zsh
# Link or copy this plugin into a local WordPress instance
# Usage:
#   ./dev-link.sh /absolute/path/to/wordpress/root [--copy]
# Example:
#   ./dev-link.sh ~/Sites/wordpress

set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 /absolute/path/to/wordpress/root [--copy]"
  exit 1
fi

WP_ROOT=$1
MODE=${2:-symlink}

if [[ ! -d "$WP_ROOT/wp-content" ]]; then
  echo "Error: '$WP_ROOT' does not look like a WordPress root (missing wp-content)."
  exit 1
fi

PLUGIN_SRC_DIR=$(cd "$(dirname "$0")" && pwd)
PLUGIN_NAME=wpaukrug
DEST_DIR="$WP_ROOT/wp-content/plugins/$PLUGIN_NAME"

mkdir -p "$WP_ROOT/wp-content/plugins"

if [[ -e "$DEST_DIR" || -L "$DEST_DIR" ]]; then
  echo "Removing existing $DEST_DIR"
  rm -rf "$DEST_DIR"
fi

if [[ "$MODE" == "--copy" || "$MODE" == "copy" ]]; then
  echo "Copying $PLUGIN_SRC_DIR -> $DEST_DIR"
  rsync -a --delete "$PLUGIN_SRC_DIR/" "$DEST_DIR/"
else
  echo "Symlinking $PLUGIN_SRC_DIR -> $DEST_DIR"
  ln -s "$PLUGIN_SRC_DIR" "$DEST_DIR"
fi

echo "Done. Open $WP_ROOT/wp-admin/plugins.php and look for 'wpaukrug'."
