#!/bin/bash
set -euo pipefail

# --- Preflight ---
if [[ ! -d "wpaukrug" ]]; then
  echo "Fehler: wpaukrug/ existiert nicht. Abbruch." >&2
  exit 1
fi
if [[ ! -d "wpaukrug/plugin" ]]; then
  echo "Fehler: wpaukrug/plugin/ existiert nicht. Abbruch." >&2
  exit 1
fi

# --- Backup ---
mkdir -p backups
STAMP=$(date +%Y%m%d_%H%M%S)
ZIP="backups/structure_backup_${STAMP}.zip"
if zip -r "$ZIP" wpaukrug -x "wpaukrug/vendor/*" "wpaukrug/plugin/vendor/*" "wpaukrug/.git/*" "wpaukrug/build/*" "wpaukrug/.dart_tool/*" "wpaukrug/node_modules/*"; then
  echo "Backup erstellt: $ZIP"
else
  echo "Warnung: Backup konnte nicht erstellt werden (zip-Fehler). Migration läuft trotzdem weiter."
fi

# --- Git branch ---
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  if [[ -z $(git status --porcelain) ]]; then
    if ! git rev-parse --verify fix/plugin-flatten >/dev/null 2>&1; then
      git checkout -b fix/plugin-flatten
      echo "Git-Branch fix/plugin-flatten erstellt."
    else
      git checkout fix/plugin-flatten
      echo "Git-Branch fix/plugin-flatten gewechselt."
    fi
  else
    echo "Warnung: Uncommittete Änderungen vorhanden. Branch wird nicht gewechselt."
  fi
fi

# --- Move files ---
PLUGIN_DIR="wpaukrug/plugin"
ROOT_DIR="wpaukrug"
CONFLICT_LOG="tools/plugin_flatten_conflicts.log"
: > "$CONFLICT_LOG"

find "$PLUGIN_DIR" -mindepth 1 -maxdepth 1 | while read SRC; do
  BASENAME=$(basename "$SRC")
  DEST="$ROOT_DIR/$BASENAME"
  if [[ -e "$DEST" ]]; then
    if cmp -s "$SRC" "$DEST"; then
      echo "Skip identisch: $BASENAME"
      continue
    else
      # Neuere Datei behalten
      if [[ "$SRC" -nt "$DEST" ]]; then
        echo "Konflikt: $BASENAME → Behalte $SRC" | tee -a "$CONFLICT_LOG"
        if git ls-files --error-unmatch "$SRC" >/dev/null 2>&1; then
          git mv -f "$SRC" "$DEST"
        else
          mv -f "$SRC" "$DEST"
        fi
      else
        echo "Konflikt: $BASENAME → Behalte $DEST" | tee -a "$CONFLICT_LOG"
        rm -rf "$SRC"
      fi
    fi
  else
    if git ls-files --error-unmatch "$SRC" >/dev/null 2>&1; then
      git mv "$SRC" "$DEST"
    else
      mv "$SRC" "$DEST"
    fi
  fi
  done

# --- Remove empty plugin dir ---
if [[ -d "$PLUGIN_DIR" ]] && [[ -z $(ls -A "$PLUGIN_DIR") ]]; then
  rmdir "$PLUGIN_DIR"
  echo "Leeres wpaukrug/plugin/ entfernt."
fi

# --- Normalize plugin entry file ---
MAIN_FILE="$ROOT_DIR/wpaukrug.php"
ALT_FILE="$ROOT_DIR/au_aukrug_connect.php"
HEADER="Plugin Name: Aukrug Connect"
if [[ -f "$MAIN_FILE" ]]; then
  if ! grep -q "$HEADER" "$MAIN_FILE"; then
    sed -i '' "1s/^/<?php\n/* $HEADER */\n/" "$MAIN_FILE"
    echo "Header in wpaukrug.php ergänzt."
  fi
elif [[ -f "$ALT_FILE" ]]; then
  if grep -q "$HEADER" "$ALT_FILE"; then
    mv "$ALT_FILE" "$MAIN_FILE"
    echo "au_aukrug_connect.php zu wpaukrug.php umbenannt."
  fi
fi

# --- Fix includes/requires ---
find "$ROOT_DIR" -type f -name "*.php" | while read PHPFILE; do
  sed -i '' -E "s/(["'])\/plugin\/includes\//\1includes\//g" "$PHPFILE"
  sed -i '' -E "s/__DIR__ ?\. ?['\"]\/plugin\//__DIR__ . '\//g" "$PHPFILE"
  sed -i '' -E "s/plugin_dir_path\( ?__FILE__ ?\) ?\. ?['\"]plugin\//plugin_dir_path( __FILE__ ) . '/g" "$PHPFILE"
  # Relative Pfade vermeiden
  sed -i '' -E "s/require(_once)? ?\(?['\"]\.\.\/plugin\//require\1(__DIR__ . '\//g" "$PHPFILE"
  sed -i '' -E "s/include(_once)? ?\(?['\"]\.\.\/plugin\//include\1(__DIR__ . '\//g" "$PHPFILE"
  done

# --- Composer autoload ---
if [[ -f "$ROOT_DIR/composer.json" ]]; then
  sed -i '' -E "s/plugin\/includes/includes/g" "$ROOT_DIR/composer.json"
  (cd "$ROOT_DIR" && composer install)
  echo "Composer install ausgeführt."
fi

# --- GitHub Actions ---
if [[ -d ".github/workflows" ]]; then
  for WF in .github/workflows/*; do
    sed -i '' -E "s/plugin\/\*\*/wpaukrug\/\*\*/g" "$WF"
  done
  echo "GitHub Actions-Filter angepasst."
fi

# --- Sanity Checks ---
echo "Sanity-Check:"
if [[ -f "$MAIN_FILE" ]]; then
  echo "✓ wpaukrug.php vorhanden."
else
  echo "✗ wpaukrug.php fehlt!"
fi
for DIR in admin includes assets; do
  if [[ -d "$ROOT_DIR/$DIR" ]]; then
    echo "✓ $DIR vorhanden."
  else
    echo "✗ $DIR fehlt!"
  fi
  done
find "$ROOT_DIR" -type f -name "*.php" | wc -l | xargs echo "PHP-Dateien:" 
find "$ROOT_DIR" -type f -name "*.json" | wc -l | xargs echo "JSON-Dateien:"
find "$ROOT_DIR" -type f -name "*.md" | wc -l | xargs echo "Markdown-Dateien:"

# --- dev-link.sh ---
if [[ -f "dev-link.sh" ]]; then
  sed -i '' -E "s/\.\/wpaukrug\/plugin/\.\/wpaukrug/g" dev-link.sh
  echo "dev-link.sh aktualisiert."
fi

# --- Quality Gates ---
if [[ -x "$ROOT_DIR/vendor/bin/phpcs" ]]; then
  (cd "$ROOT_DIR" && vendor/bin/phpcs --standard=PSR12)
fi
if [[ -x "$ROOT_DIR/vendor/bin/phpunit" ]]; then
  (cd "$ROOT_DIR" && vendor/bin/phpunit)
fi

# --- NEXT STEPS ---
echo "\nNEXT STEPS:"
echo "1) Review git diff und commit:"
echo "   git add -A && git commit -m \"chore(plugin): flatten to /wpaukrug and fix includes/autoload\""
echo "2) Run quality gates:"
echo "   (cd wpaukrug && vendor/bin/phpcs --standard=PSR12)"
echo "   (cd wpaukrug && vendor/bin/phpunit)   # falls Tests vorhanden"
echo "3) Plugin in WordPress aktivieren und Admin prüfen."
