# Git Sync Workflow - Quick Start

## 🚀 Daily Sync (Der wichtigste Command)

```bash
cd wpaukrug
make sync-all
```

Das wars! Dieser Command:

- Zeigt den aktuellen Status
- Committet automatisch Änderungen  
- Pullt von beiden Remotes (GitHub + Forgejo)
- Führt Tests aus
- Pusht zu beiden Remotes
- Zeigt den finalen Status

## 📚 Vollständige Dokumentation

Siehe: [`wpaukrug/docs/GIT_WORKFLOW.md`](wpaukrug/docs/GIT_WORKFLOW.md)

## ⚡ Quick Commands

| Command | Was passiert |
|---------|-------------|
| `make help` | Alle verfügbaren Commands |
| `make status` | Git Status Overview |
| `make sync-all` | **Vollständiger Sync** |
| `./bin/sync.sh --help` | Sync Script Optionen |

## 🔧 Git Aliases

Nach dem Setup verfügbar:

- `git sync-all` 
- `git sync-status`
- `git pull-all`
- `git push-all`
- `git sync-script`

## 📁 Repository Struktur

```
aukrug/
├── wpaukrug/           # WordPress Plugin + Sync Tools
│   ├── Makefile        # Sync Commands  
│   ├── bin/sync.sh     # Sync Script
│   ├── docs/           # Dokumentation
│   └── .git-hooks/     # Git Hooks
└── app/               # Flutter App
```

---

**💡 Tipp:** Nutze `make sync-all` täglich für problemlose Synchronisation zwischen GitHub und Forgejo!
