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
