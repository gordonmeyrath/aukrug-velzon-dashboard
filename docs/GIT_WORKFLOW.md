# Git Workflow - Aukrug Workspace

## Repository-Setup

**Lokales Repository**: `/Users/gordonmeyrath/Documents/Development/flutter/aukrug`
**Remote Backend**: `~/mioconnex/api` auf `miocity` (10.0.1.11)

### Remotes
- **origin**: `git@github.com:MioWorkx/aukrug_workspace.git` (GitHub - Primary)
- **mirror**: `ssh://git@git.mioconnex.local:22/gordonmeyrath/aukrug_workspace.git` (Forgejo - Backup)

## Branch-Strategie

### Main Branch
- `main` - Produktions-Branch
- Alle Änderungen werden hier gemergt
- Automatische Synchronisation zwischen GitHub ↔ Forgejo

### Feature Workflow
```bash
# Neues Feature starten
git checkout -b feature/awesome-feature

# Entwicklung...
git add .
git commit -m "feat: implement awesome feature"

# Vor Push: Pre-Push-Hook läuft
# - Clean working tree check
# - Flutter analyze (falls app/pubspec.yaml existiert)
# - Flutter test (falls app/pubspec.yaml existiert)

# Push zu GitHub
git push origin feature/awesome-feature

# Pull Request erstellen, Review, Merge
# Nach Merge: Branch löschen
git branch -d feature/awesome-feature
```

## Makefile-Kommandos

### Status prüfen
```bash
make status
```
Zeigt Git-Status, Remotes und aktuellen Branch.

### Synchronisation
```bash
# Alle Remotes pullen
make pull-all

# Alle Remotes pushen  
make push-all

# Vollständige Synchronisation
make sync-all  # pull-all + push-all
```

### Tags verwalten
```bash
make tags  # Zeigt lokale und Remote-Tags
```

## Workspace-Struktur

```
aukrug/
├── .git/
│   └── hooks/
│       └── pre-push*          # Automatische Checks vor Push
├── .gitignore                 # Flutter + Node + WP Artefakte
├── Makefile                   # Git-Operationen
├── docs/
│   ├── ANALYSE.md            # Architektur-Dokumentation
│   └── GIT_WORKFLOW.md       # Diese Datei
└── api/
    └── openapi.yaml          # API-Spezifikation
```

## Remote-Backend Sync

### Lokale Änderungen → Remote
```bash
# OpenAPI-Datei hochladen
scp api/openapi.yaml miocity:~/mioconnex/api/api/openapi.yaml

# Komplettes Projekt-Sync (nach Backend-Setup)
rsync -av --exclude='.git' --exclude='node_modules' \
  /path/to/local/ miocity:~/mioconnex/api/
```

### Remote → Lokal (Logs, Configs)
```bash
# Logs herunterladen
scp miocity:~/mioconnex/api/logs/app.log ./logs/

# Config-Files synchronisieren
scp miocity:~/mioconnex/api/.env.example ./backend/.env.example
```

## Deployment-Workflow

### Development
1. **Lokal entwickeln**: Flutter-App, API-Design
2. **Backend testen**: `ssh miocity 'cd ~/mioconnex/api && npm run dev'`
3. **Commit & Sync**: `make sync-all`

### Production  
1. **Tag erstellen**: `git tag v1.0.0 && git push --tags`
2. **Remote Build**: `ssh miocity 'cd ~/mioconnex/api && npm run build'`
3. **Service Restart**: `ssh miocity 'sudo systemctl restart mioconnex-api'`

## Troubleshooting

### Git-Remotes reparieren
```bash
git remote remove origin mirror 2>/dev/null || true
git remote add origin git@github.com:MioWorkx/aukrug_workspace.git
git remote add mirror ssh://git@git.mioconnex.local:22/gordonmeyrath/aukrug_workspace.git
```

### SSH-Probleme
```bash
# Testen der SSH-Verbindung
ssh miocity 'echo "Connection OK"'

# Git über SSH testen
ssh -T git@github.com
ssh -T git@git.mioconnex.local
```

### Hook-Probleme
```bash
# Pre-push Hook reparieren
chmod +x .git/hooks/pre-push

# Hook temporär deaktivieren
git push --no-verify origin main
```

## Konventionen

### Commit-Messages
```
feat: neue Funktion
fix: Bugfix
docs: Dokumentation
style: Code-Formatierung
refactor: Code-Refactoring
test: Tests hinzugefügt
chore: Build/Tool-Änderungen
```

### Branch-Naming
```
feature/kurze-beschreibung
bugfix/issue-123
hotfix/critical-fix
release/v1.0.0
```

## Automatisierung

### Pre-Push Hook
- ✅ Working Tree sauber
- ✅ Flutter analyze (falls Flutter-Projekt)
- ✅ Flutter tests (falls Flutter-Projekt)

### CI/CD (geplant)
- **GitHub Actions**: Lint, Test, Build
- **Forgejo CI**: Mirror-Builds, Deployment
- **Auto-Deployment**: Bei Tag-Push auf `miocity`
