# Aukrug Workspace

A dual-remote monorepo containing a Flutter mobile application and WordPress plugin for the Aukrug municipality platform.

## 🏗️ Architecture

```
aukrug_workspace/
├── app/          # Flutter mobile application
├── plugin/       # WordPress plugin (aukrug-connect)
├── tool/         # Development and deployment scripts
├── docs/         # Documentation
├── .github/      # CI/CD workflows
└── backups/      # Automated backups
```

## 🔄 Dual Remote Setup

This repository uses a dual-remote strategy:

- **Primary (Forgejo)**: `git@git.mioconnex.local:mioconnex/aukrug_workspace.git`
- **Backup (GitHub)**: `git@github.com:MioWorkx/aukrug_workspace.git` *(private)*

All pushes go to both remotes simultaneously via the `git pub` alias.

## 🚀 Quick Start

### Prerequisites

- Flutter SDK (3.24+)
- PHP 8.2+
- Composer
- Git with SSH keys configured for both Forgejo and GitHub

### Initial Setup

1. **Clone the repository**:
   ```bash
   git clone git@git.mioconnex.local:mioconnex/aukrug_workspace.git
   cd aukrug_workspace
   ```

2. **Set up API tokens** (for automated repo creation only):
   ```bash
   export FORGEJO_TOKEN=your_forgejo_token
   export GITHUB_TOKEN=your_github_token
   ```
   
   > ⚠️ **Security Note**: Tokens are only used to create remote repositories via API. 
   > All git operations use SSH. Never commit real tokens to the repository.

3. **Bootstrap dual remotes**:
   ```bash
   make bootstrap
   ```

4. **Load developer aliases**:
   ```bash
   source tool/scripts/dev-aliases.sh
   ```

### Development Workflow

```bash
# Flutter app
make app-gen     # Generate code and get dependencies
make app-test    # Run tests
make app-analyze # Static analysis

# WordPress plugin
make plugin-lint # PHP CodeSniffer (PSR-12)
make plugin-test # PHPUnit tests

# Workspace
make backup      # Create timestamped backup
gpub            # Push to both remotes
gci "message"   # Quick commit
```

## 📱 Flutter App

**Location**: `./app/`

Feature-first architecture with:
- **State Management**: Riverpod
- **Navigation**: GoRouter  
- **Networking**: Dio with offline-first caching
- **Local Storage**: Hive/Isar
- **Maps**: Flutter Map
- **Code Generation**: Freezed, JSON Serializable

**Key Features**:
- Tourist/Resident user modes
- Offline-first with delta sync
- Multilingual (DE/EN)
- DSGVO compliant
- Accessibility features

## 🔌 WordPress Plugin

**Location**: `./plugin/`

REST API plugin providing:
- **Namespace**: `/wp-json/aukrug/v1/`
- **Custom Post Types**: place, route, event, notice, download, provider, report
- **Taxonomies**: audience (tourist/resident/kita/schule), category
- **Authentication**: JWT for resident features
- **Sync**: Delta sync with ETag/Last-Modified

**Endpoints**:
- `GET /places, /routes, /events, /notices, /downloads`
- `GET /sync/changes?since=timestamp`
- `POST /reports` (with media support)

## 🔐 Security & Privacy

### DSGVO/GDPR Compliance
- Privacy by design architecture
- No tracking of users under 16
- Minimal data collection
- Clear consent flows
- Data export/deletion capabilities
- Audit logging

### Token Management
- API tokens stored in environment variables only
- SSH keys for all git operations
- GitHub repository is **private**
- No secrets in codebase

### Setting Up Tokens Safely

1. **Generate tokens**:
   - Forgejo: `http://git.mioconnex.local/user/settings/applications`
   - GitHub: `https://github.com/settings/tokens` (scope: `repo`)

2. **Use environment variables**:
   ```bash
   cp .env.sample .env
   # Edit .env with your actual tokens
   source .env
   ```

3. **Never commit `.env`** - it's in `.gitignore`

## 🔧 CI/CD

### GitHub Actions
- **Flutter CI**: Analyze, test, build APK/IPA on `app/**` changes
- **PHP CI**: PHPCS, PHPUnit on `plugin/**` changes

### Local Development
```bash
# Check status
make help

# Run all checks
make app-analyze app-test plugin-lint plugin-test
```

## 📚 Documentation

- [Workspace Context](docs/WORKSPACE_CONTEXT.md) - Vision and architecture
- [App Documentation](app/docs/) - Flutter app specifics  
- [Plugin Documentation](plugin/docs/) - WordPress plugin details

## 🛠️ Available Commands

### Make Targets
```bash
make bootstrap    # Set up dual-remote repository
make backup       # Create timestamped backup
make app-gen      # Flutter code generation
make app-test     # Run Flutter tests
make plugin-lint  # PHP CodeSniffer
make plugin-test  # PHPUnit tests
```

### Git Aliases (after `source tool/scripts/dev-aliases.sh`)
```bash
gpub             # Push to both remotes
gci "message"    # Quick commit with message
```

## 🔍 Integration

The Flutter app and WordPress plugin are designed to work together:

- **API Contract**: Shared interface definitions
- **Fixtures**: Plugin provides test data for app development
- **Delta Sync**: Efficient offline-first synchronization
- **Media Handling**: Optimized image delivery and caching

## 📞 Support

For development questions, see the documentation in `docs/` or check the individual project README files in `app/` and `plugin/`.

---

**Repository**: Dual-remote (Forgejo primary, GitHub backup)  
**License**: Private/Proprietary  
**DSGVO**: Compliant by design
