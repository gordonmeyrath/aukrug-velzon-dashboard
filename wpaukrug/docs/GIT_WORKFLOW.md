# Git Sync Workflow - Aukrug Workspace

## Übersicht

Dieses Repository verwendet eine **Dual-Remote-Strategie** für robuste Code-Synchronisation zwischen:

- **GitHub** (origin) - Haupt-Repository
- **Forgejo** (mirror) - Mirror/Backup-Repository

## Setup

### 1. Remotes konfigurieren

```bash
# GitHub als origin
git remote add origin https://github.com/username/repo.git

# Forgejo als mirror  
git remote add mirror https://forgejo.instance.com/username/repo.git

# Überprüfen
git remote -v
```

### 2. Branch auf main setzen

```bash
make set-branch
# oder
git branch -M main
```

## Verfügbare Commands

### Make Targets

| Command | Beschreibung |
|---------|-------------|
| `make help` | Zeigt alle verfügbaren Commands |
| `make status` | Git Status, Remotes und Recent Commits |
| `make pull-all` | Pull von beiden Remotes mit Rebase |
| `make push-all` | Push zu beiden Remotes inkl. Tags |
| `make sync-all` | **Vollständiger Sync-Workflow** |
| `make test` | Führt verfügbare Tests aus (Flutter, npm) |
| `make set-branch` | Setzt main als Default-Branch |

### Git Aliases

Nach dem Setup sind diese Aliases verfügbar:

```bash
git sync-status    # = make status
git sync-all       # = make sync-all  
git pull-all       # = make pull-all
git push-all       # = make push-all
git sync-script    # = bin/sync.sh
```

### Sync Script

Das `bin/sync.sh` Script bietet erweiterte Optionen:

```bash
# Standard Sync
./bin/sync.sh

# Bestimmten Branch syncen
./bin/sync.sh develop

# Force Mode (überschreibt Remote-Changes)
./bin/sync.sh --force main

# Verbose Output
./bin/sync.sh --verbose

# Hilfe anzeigen
./bin/sync.sh --help
```

## Typische Workflows

### 🚀 Schneller Daily Sync

```bash
make sync-all
```

**Das ist der wichtigste Command!** Er führt aus:

1. Status anzeigen
2. Änderungen auto-committen (falls vorhanden)
3. Von beiden Remotes pullen
4. Tests ausführen
5. Zu beiden Remotes pushen  
6. Final Status anzeigen

### 📊 Status Check

```bash
make status
# oder
git sync-status
```

### 📥 Nur Pull Operations

```bash
make pull-all
# oder
git pull-all
```

### 📤 Nur Push Operations  

```bash
make push-all
# oder
git push-all
```

### 🔧 Script mit Optionen

```bash
# Force sync wenn Konflikte bestehen
./bin/sync.sh --force

# Verbose für Debugging
./bin/sync.sh --verbose main
```

## Sicherheitsfeatures

### Pre-Push Hook

Automatische Validierung vor jedem Push:

- ✅ Connectivity Check zu Remotes
- ✅ Scan nach sensitiven Dateien
- ✅ PHP Syntax Check
- ✅ Flutter Analysis (wenn verfügbar)
- ✅ Branch-Namen Validation

### Sensible Dateien

Der Hook warnt vor diesen Dateien:

- `.env*` Files
- Private Keys (`.pem`, `.p12`, `.pfx`)  
- `wp-config.php`
- Dateien mit "password", "secret", "key" im Namen

## Repository Struktur

```
wpaukrug/                    # WordPress Plugin
├── Makefile                 # Sync Commands
├── bin/
│   └── sync.sh             # Sync Script  
├── docs/
│   └── GIT_WORKFLOW.md     # Diese Dokumentation
├── .git-hooks/
│   └── pre-push            # Validation Hook
├── includes/               # Plugin Classes
├── admin/                  # Admin Interface
└── tests/                  # PHPUnit Tests

app/                        # Flutter App
├── lib/                    # Dart Code
├── test/                   # Flutter Tests
└── pubspec.yaml           # Dependencies
```

## Troubleshooting

### Problem: Remote nicht erreichbar

```bash
# Connectivity testen
git fetch origin --dry-run
git fetch mirror --dry-run

# DNS/Network prüfen  
ping github.com
ping forgejo.instance.com
```

### Problem: Working Directory nicht clean

```bash
# Manuelle Lösung
git add -A
git commit -m "chore: cleanup before sync"

# Oder Force Mode verwenden
./bin/sync.sh --force
```

### Problem: Merge Konflikte

```bash
# Nach failed rebase
git status
# Konflikte manuell lösen...
git add resolved-files
git rebase --continue

# Oder Reset zu Remote State
git reset --hard origin/main
```

### Problem: Hook Fehler

```bash
# Hook temporär deaktivieren
git config core.hooksPath ""

# Push durchführen
git push origin main

# Hook wieder aktivieren  
git config core.hooksPath .git-hooks
```

## Best Practices

### ✅ DO

- Nutze `make sync-all` für tägliche Syncs
- Committe regelmäßig kleine Änderungen
- Teste lokaal vor dem Push
- Nutze beschreibende Commit-Messages
- Prüfe Status vor größeren Operations

### ❌ DON'T  

- Pushe nie Secrets oder Credentials
- Verwende keine Force-Pushes ohne Grund
- Ignoriere Hook-Warnungen nicht
- Committe keine `.env` Dateien
- Vergesse nicht die Mirror-Remote zu aktualisieren

## Erweiterte Configuration

### Custom Branch Patterns

```bash
# Hook anpassen für andere Branch-Namen
vim .git-hooks/pre-push
# Pattern in "sensitive_patterns" Array erweitern
```

### Zusätzliche Remotes

```bash
# Weitere Backup-Remote hinzufügen
git remote add backup2 https://gitlab.com/user/repo.git

# Im Script erweitern (bin/sync.sh)
# Neue Remote zu "sync_branch" Function hinzufügen
```

### IDE Integration

#### VS Code

Füge zu `.vscode/tasks.json` hinzu:

```json
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "Git Sync All",
      "type": "shell", 
      "command": "make sync-all",
      "group": "build",
      "presentation": {
        "echo": true,
        "reveal": "always"
      }
    }
  ]
}
```

#### Terminal Aliases

Füge zu `~/.zshrc` oder `~/.bashrc` hinzu:

```bash
alias gs="make sync-all"
alias gst="make status"
alias gpa="make pull-all"
alias gph="make push-all"
```

## Support

Bei Problemen:

1. `make status` für aktuellen Zustand
2. `./bin/sync.sh --verbose` für detaillierte Logs
3. `.git-hooks/pre-push` Hook-Logs prüfen
4. Git-Config überprüfen: `git config --list | grep -E "(remote|alias|hooks)"`

---

**Wichtiger Hinweis:** Der `make sync-all` Command ist der empfohlene Weg für tägliche Synchronisation. Er behandelt alle Edge Cases automatisch und sorgt für konsistente Repository-Zustände auf beiden Remotes.
