# Aukrug App - Context & Scope

## Overview

The Aukrug App is a **dual-audience mobile application** serving both tourists and residents of the Aukrug municipality in Schleswig-Holstein, Germany. The app provides location-based services, community information, and municipal services through an intuitive, GDPR-compliant interface.

## Target Audiences

### Tourists ("Ich besuche Aukrug")

- **Discover**: Interactive map with places of interest, routes, and local attractions
- **Routes & Trails**: Hiking and cycling routes with GPX support
- **Events**: Public events and festivals
- **Places**: Restaurants, accommodations, shops, and services
- **Info**: Practical information for visitors

### Residents ("Ich lebe hier")  

- **Notices**: Municipal announcements and important community news
- **Events**: Local community events and meetings
- **Downloads**: Official documents, forms, and municipal resources
- **Report (Mängelmelder)**: Report infrastructure issues and municipal concerns
- **Settings**: Accessibility options and privacy controls

## Core Features

### Offline-First Architecture

- Local data storage using **Isar database** for fast access
- Fixture data ensures UI is never empty
- ETag-based caching for efficient data synchronization
- Graceful fallback when network is unavailable

### GDPR Compliance

- **Explicit consent** for all data processing
- **Data minimization** - only necessary data stored
- **Granular permissions**: Analytics (opt-out), Push notifications (opt-in), Location (optional)
- **Right to be forgotten** - clear data anytime

### Accessibility

- High-contrast mode toggle
- Large text options
- Dyslexia-friendly font support (placeholder)
- Screen reader compatibility

### Localization

- Primary: German (de)
- Secondary: English (en)
- Municipal-specific terminology and regional content

## Technical Stack

- **Framework**: Flutter 3.24+ with Material 3 design
- **State Management**: Riverpod with code generation
- **Navigation**: GoRouter with shell routes
- **Networking**: Dio with custom interceptors (auth, ETag, logging)
- **Local Storage**: Isar (chosen over Hive for better performance)
- **Maps**: flutter_map with OpenStreetMap tiles
- **Serialization**: Freezed + json_serializable

## Data Sources

- **Primary API**: WordPress plugin at `/wp-json/aukrug/v1/*`
- **Fixture Data**: Local JSON files in `assets/fixtures/`
- **User Preferences**: SharedPreferences for lightweight data
- **Structured Data**: Isar database for complex entities

## Privacy by Design

1. **Local-first**: Most data stored and processed locally
2. **Minimal API calls**: Only when necessary, with caching
3. **No tracking**: Analytics disabled by default
4. **Transparent permissions**: Clear explanations for all data use
5. **User control**: All settings changeable anytime

## Development Approach

- **Feature-first architecture** for maintainability
- **Test-driven development** with unit, widget, and integration tests
- **Code generation** for reducing boilerplate and errors
- **Progressive Web App** ready architecture
- **CI/CD integration** with GitHub Actions
