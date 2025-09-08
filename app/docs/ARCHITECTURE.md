# Aukrug App - Architecture Documentation

## Overview

The Aukrug App follows a **feature-first architecture** with clean separation of concerns, dependency injection via Riverpod, and offline-first data management. The architecture ensures maintainability, testability, and scalability while providing excellent user experience.

## Project Structure

```
lib/
├── core/                    # Shared infrastructure
│   ├── config/             # Environment configuration
│   ├── network/            # HTTP client & interceptors
│   └── storage/            # Local database setup
├── features/               # Feature modules
│   ├── shell/              # Navigation shells (tourist/resident)
│   ├── auth/               # Consent & audience selection
│   ├── places/             # Places of interest
│   ├── events/             # Events & calendar
│   ├── notices/            # Municipal notices
│   ├── downloads/          # Document management
│   ├── reports/            # Mängelmelder (issue reporting)
│   └── settings/           # User preferences
├── router/                 # Navigation configuration
├── shared/                 # Shared UI components
└── l10n/                  # Localization files
```

## Architectural Principles

### 1. Feature-First Organization

Each feature is self-contained with its own:

- **Presentation Layer**: Pages, widgets, state notifiers
- **Domain Layer**: Models, business logic
- **Data Layer**: Repositories, data sources

Benefits:

- Easy to locate related code
- Clear ownership boundaries
- Simplified testing and maintenance

### 2. Dependency Injection

**Riverpod providers** manage all dependencies:

```dart
// Core providers
@riverpod
AppConfig appConfig(AppConfigRef ref) => AppConfig();

@riverpod
Dio dioClient(DioClientRef ref) => DioClient(ref.watch(appConfigProvider));

@riverpod
IsarDatabase isarDatabase(IsarDatabaseRef ref) => IsarDatabase();

// Feature-specific providers
@riverpod
PlacesRepository placesRepository(PlacesRepositoryRef ref) =>
    PlacesRepository(
      dio: ref.watch(dioClientProvider),
      isar: ref.watch(isarDatabaseProvider),
    );
```

### 3. Offline-First Data Strategy

**Data Flow**:

1. Always show local data first (instant UI)
2. Check for network connectivity
3. Fetch remote data with ETag caching
4. Merge remote changes with local data
5. Update UI with new data

**Storage Layers**:

- **Isar Database**: Complex entities (Places, Events, Notices)
- **SharedPreferences**: Simple key-value data (user preferences)
- **Assets**: Static fixture data for offline fallback

#### Incremental Sync & Data Origin (Reports Feature)

The reports module implements an evolving offline model with explicit origin tracking and delta-ready refresh logic.

DataOrigin enum:

```
enum DataOrigin { freshFullSync, cachePrimed, cacheOnly }
```

Meaning:

- freshFullSync: A complete dataset load just updated the cache (baseline reference; updates `lastFullSyncAt`).
- cachePrimed: Cached data served instantly while a background refresh (full or delta) runs.
- cacheOnly: Only cached data available (offline or repeated refresh failures/backoff).

State Additions:

- `lastFullSyncAt`: Timestamp of last confirmed full dataset load.
- `newSinceSyncCount`: Number of reports changed/added since `lastFullSyncAt`.
- `showOnlyNewSinceSync`: UI filter to narrow view to incremental changes.
- `dataOrigin`: Current origin category (not persisted; session scope).

Refresh Logic:

1. First load: cache-first (if available) → background refresh.
2. `refreshOrDeltaSync(lastFullSyncAt)`: attempts delta (`fetchChangesSince`) else falls back to full sync.
3. Merge strategy: Replace by ID; prefer record with latest `updatedAt` (fallback `submittedAt`).
4. Exponential backoff on failures (2s,4s,8s... capped at 60s) marks origin `cacheOnly` if failures persist.

UI Feedback:

- Badge in AppBar displays `newSinceSyncCount` (capped at 99+).
- FilterChip “Neu seit Sync”.
- SnackBar appears when a delta introduces new items (without a full sync) offering quick filter activation.
- Distinct icons: `cachePrimed` (cloud_sync), `cacheOnly` (cloud_off), offline (wifi_off).

Persistence:

- Preferences store: query, category, status, sort, staleMinutes, lastFullSyncAt, showOnlyNewSinceSync.
- Not stored: dataOrigin, newSinceSyncCount (recomputed for session integrity).

Planned Extensions:

- Real delta endpoint `/reports?since=ISO8601` including deletions (tombstone list or deletedAt field).
- Conflict audit & optimistic submission reconciliation.
- Cache schema versioning; mismatch triggers mandatory full sync.


### 4. Code Generation

**Generated Components**:

- **Freezed**: Immutable data classes with copyWith, equality
- **json_serializable**: JSON serialization/deserialization
- **Riverpod**: Provider classes and dependency injection

**Build Command**:

```bash
dart run build_runner build --delete-conflicting-outputs
```

## Core Components

### AppConfig

Environment-aware configuration:

```dart
@riverpod
class AppConfig extends _$AppConfig {
  String get baseUrl => 'https://aukrug.de/wp-json/aukrug/v1';
  String get environment => kDebugMode ? 'development' : 'production';
  Duration get cacheTimeout => const Duration(hours: 1);
}
```

### DioClient

HTTP client with interceptors:

- **AuthInterceptor**: Automatic token management
- **ETagInterceptor**: Smart caching based on HTTP ETags
- **LoggingInterceptor**: Request/response logging for debugging

### IsarDatabase

Local database configuration:

```dart
@riverpod
class IsarDatabase extends _$IsarDatabase {
  late Isar _isar;
  
  Future<void> initialize() async {
    _isar = await Isar.open([
      PlaceSchema,
      EventSchema,
      NoticeSchema,
    ]);
  }
}
```

## Navigation Architecture

### Shell Routes

Dual navigation shells for different audiences:

```dart
ShellRoute(
  path: '/tourist',
  builder: (context, state, child) => TouristShell(child: child),
  routes: [
    GoRoute(path: '/places', page: PlacesPage),
    GoRoute(path: '/events', page: EventsPage),
    GoRoute(path: '/routes', page: RoutesPage),
  ],
),
ShellRoute(
  path: '/resident',
  builder: (context, state, child) => ResidentShell(child: child),
  routes: [
    GoRoute(path: '/notices', page: NoticesPage),
    GoRoute(path: '/downloads', page: DownloadsPage),
    GoRoute(path: '/reports', page: ReportsPage),
  ],
),
```

### Navigation Flow

1. **Splash** → Loading and initialization
2. **Consent** → GDPR compliance check
3. **Audience Picker** → Tourist vs. Resident selection
4. **Shell Navigation** → Feature-specific bottom navigation

## Community Module

The Community module provides a BuddyBoss-inspired social layer with a feed, groups, messages, notifications, and profiles. It currently uses fixture-backed data and Riverpod providers, with an offline-first path planned using Isar.

Structure:

```
features/community/
  domain/        # Plain Dart models: user, group, post, message
  data/          # CommunityApi loads from assets/fixtures/community/*.json
  application/   # Riverpod providers (users, groups, feed, messages)
  presentation/  # CommunityShell + pages (feed, groups, messages, notifications, profile)
```

Routing:

```
/community/feed
/community/groups
/community/groups/:id       # detail (planned)
/community/messages
/community/messages/:id     # chat detail (planned)
/community/notifications
/community/profile
```

Design System:

- Central theme in `core/theme/app_theme.dart`
- BuddyBoss-inspired tokens/components in `core/design/*` (AppButton, AppCard, Avatar, Badge)
- Applied globally; pages adopt consistent typography and cards

Data Loading:

- `CommunityApi` uses rootBundle to read JSON fixtures under `assets/fixtures/community/`
- Providers expose lists for UI: `usersProvider`, `groupsProvider`, `feedProvider`, `messagesProvider`
- Optimistic methods stubbed: `createPost`, `sendMessage`

Next Steps:

- Add Isar schemas/repositories for offline caching and sync
- Implement group/chat detail screens
- Wire optimistic updates and in-app notification overlays

## State Management

### Riverpod Patterns

**AsyncNotifier** for remote data:

```dart
@riverpod
class PlacesNotifier extends _$PlacesNotifier {
  @override
  Future<List<Place>> build() async {
    // Return local data first
    final places = await ref.read(placesRepositoryProvider).getLocal();
    
    // Fetch remote updates
    ref.read(placesRepositoryProvider).syncFromRemote();
    
    return places;
  }
}
```

**StateNotifier** for UI state:

```dart
@riverpod
class SelectedAudience extends _$SelectedAudience {
  @override
  Audience? build() => null;
  
  void select(Audience audience) {
    state = audience;
  }
}
```

## Data Models

### Freezed Models

Type-safe, immutable data classes:

```dart
@freezed
class Place with _$Place {
  const factory Place({
    required String id,
    required String name,
    required String description,
    required LatLng coordinates,
    required PlaceCategory category,
    String? website,
    String? phone,
    @Default([]) List<String> images,
  }) = _Place;
  
  factory Place.fromJson(Map<String, dynamic> json) => _$PlaceFromJson(json);
}
```

## Testing Strategy

### Test Organization

```
test/
├── unit/                   # Pure logic tests
│   ├── models/            # Data model tests
│   └── repositories/      # Business logic tests
├── widget/                # UI component tests
│   └── pages/            # Page-level widget tests
└── integration/           # End-to-end tests
    └── flows/            # User journey tests
```

### Test Categories

1. **Unit Tests**: Models, utilities, business logic
2. **Widget Tests**: UI components, user interactions
3. **Integration Tests**: Complete user flows
4. **Golden Tests**: Visual regression testing

## Performance Considerations

### Lazy Loading

- Features loaded on-demand
- Images cached with network optimization
- Database queries optimized with indexes

### Memory Management

- Dispose controllers and streams properly
- Use const constructors for immutable widgets
- Implement efficient list rendering with ListView.builder

### Network Optimization

- ETag caching reduces unnecessary downloads
- Compressed JSON responses
- Progressive image loading

## Security & Privacy

### Data Encryption

- Sensitive data encrypted at rest (if any)
- HTTPS-only communication
- No sensitive data in SharedPreferences

### Privacy Controls

- Granular consent management
- Local data processing preference
- Clear data deletion capability

### GDPR Compliance

- **Lawful basis**: Legitimate interest for municipal services
- **Data minimization**: Only necessary data collected
- **Retention policy**: User-controlled data lifecycle
- **Audit trail**: All data processing logged
