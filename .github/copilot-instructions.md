# Copilot Instructions for Aukrug Municipality Platform

## Project Architecture

This is a **dual-remote monorepo** for Aukrug municipality platform with two main components:

- `/app` - Flutter mobile app (tourists & residents)
- `/plugin` - WordPress REST API plugin with GDPR compliance  
- `/tool` - Development scripts and automation

**Dual-Remote Setup**: Primary git remote on Forgejo (`git.mioconnex.local`), backup on GitHub. Use `git push forgejo master && git push github master` or aliases from `tool/scripts/dev-aliases.sh`.

## Essential Workflows

### Development Setup
```bash
# Load git aliases and development tools
source tool/scripts/dev-aliases.sh

# Flutter development
cd app && flutter pub get && dart run build_runner build
flutter run

# WordPress plugin development  
cd plugin && composer install && composer test
```

### Code Generation (Critical)
Flutter app uses **freezed + json_serializable + riverpod_generator**:
```bash
cd app && dart run build_runner build --delete-conflicting-outputs
```
Always run after modifying `@freezed`, `@JsonSerializable`, or `@riverpod` classes.

### Testing
```bash
make app-test        # Flutter tests
make plugin-test     # PHPUnit tests  
make app-analyze     # Flutter static analysis
```

## Project-Specific Patterns

### Flutter App Structure
- **Feature-first** architecture: `lib/features/{shell,auth,places,routes_trails,events,notices,downloads,reports,settings}/`
- **Core modules**: `lib/core/{config,network,storage,util}/`
- **Storage choice**: Uses **Isar** (not Hive) for offline-first architecture
- **State management**: Riverpod with code generation (`@riverpod` annotations)
- **Navigation**: GoRouter with shell routes for dual audience (tourists/residents)

### WordPress Plugin Patterns
- **Namespace**: All classes prefixed with `Aukrug` (e.g., `AukrugCPT`, `AukrugREST`)
- **GDPR compliance**: Audit log table, data processing consent tracking
- **REST API**: Endpoints at `/wp-json/aukrug/v1/*`
- **File structure**: `includes/class-aukrug-*.php` for main classes

### Dual-Audience Design
App has **two distinct user flows**:
1. **Tourists**: Discover (Map+List), Routes, Events, Places, Info
2. **Residents**: Notices, Events, Downloads, Report (Mängelmelder), Settings

Audience picker on first launch determines shell layout.

### Networking & Offline Strategy
- **Dio client** with interceptors: auth (JWT), etag (304 responses), logging
- **Repository pattern**: Load fixtures first, then attempt network sync
- **ETag-based caching** for efficient bandwidth usage
- Base URL from `ENV.apiBase` environment configuration

### GDPR & Privacy
- **Consent management**: Analytics (opt-out), push notifications (opt-in), location (optional)
- **Data minimization**: Only store necessary data locally
- **Audit logging**: All data access tracked in WordPress plugin

## Integration Points

- **API Contract**: WordPress plugin exposes REST endpoints, Flutter app consumes
- **Map integration**: OpenStreetMap tiles via flutter_map with marker clustering
- **Localization**: German primary (`l10n_de.arb`), English secondary (`l10n_en.arb`)
- **Accessibility**: High-contrast, larger text, dyslexia-friendly font toggles

## Critical Dependencies

**Flutter**: riverpod ^2.4.9, go_router ^12.1.3, dio ^5.4.0, isar ^3.1.0+1, flutter_map ^6.2.1
**WordPress**: PHP 8.2+, WordPress 6.0+, PSR-12 coding standards

Use `pubspec.yaml` dependency versions exactly - version conflicts resolved for this project.
