# Aukrug Marketplace System

Ein vollständiges Marktplatz-System für die Aukrug Community App mit WordPress Backend und Flutter Frontend.

## Übersicht

Das Marketplace-System ermöglicht es Bewohnern und Unternehmen in Aukrug, Angebote zu erstellen, zu durchsuchen und zu verwalten. Das System ist DSGVO-konform und bietet erweiterte Sicherheitsfeatures.

## Features

### 🏪 Core Marketplace-Funktionen

- **Anzeigen erstellen und bearbeiten**: Vollständige CRUD-Operationen für Marktplatz-Anzeigen
- **Kategorisierung**: Hierarchische Kategorien für bessere Organisation
- **Bildergalerie**: Bis zu 5 Bilder pro Anzeige mit automatischer EXIF-Entfernung
- **Suchfunktion**: Volltext-Suche mit Filtern und Sortierung
- **Favoritenverwaltung**: Speichern und verwalten von Lieblingsanzeigen

### 🔐 Sicherheit & Verifizierung

- **Benutzerverifizierung**: Mehrstufiges Verifizierungssystem (Gast/Benutzer/Anwohner/Unternehmen)
- **Rate Limiting**: Schutz vor Spam (5 Erstellungen/Tag, 20 Bearbeitungen/Tag)
- **Abuse Reporting**: Community-basierte Moderation mit Meldungssystem
- **DSGVO-Compliance**: Automatische EXIF-Entfernung, keine GPS-Koordinaten

### 📱 Benutzerfreundlichkeit

- **Offline-Support**: Caching und Offline-Funktionalität
- **Pull-to-Refresh**: Einfache Aktualisierung von Listen
- **Infinite Scroll**: Performante Darstellung großer Listen
- **Responsive Design**: Optimiert für alle Bildschirmgrößen

## Architektur

### Backend (WordPress)

```
wpaukrug/includes/class-aukrug-marketplace.php
├── Custom Post Type: market_listing
├── REST API Endpoints
├── Verifizierungssystem
├── Rate Limiting
├── Image Processing (EXIF Removal)
└── Admin Interface
```

### Frontend (Flutter)

```
lib/features/marketplace/
├── screens/           # UI Screens
├── widgets/          # Reusable Components
├── models/           # Freezed Data Models
├── controllers/      # Riverpod State Management
├── repository/       # Business Logic Layer
└── api/             # REST API Client
```

## Datenmodelle

### MarketplaceListing

```dart
@freezed
class MarketplaceListing with _$MarketplaceListing {
  const factory MarketplaceListing({
    required int id,
    required String title,
    required String description,
    required double price,
    required String locationArea,
    required List<String> images,
    required String authorName,
    required DateTime createdAt,
    // ... weitere Felder
  }) = _MarketplaceListing;
}
```

### MarketplaceCategory

```dart
@freezed
class MarketplaceCategory with _$MarketplaceCategory {
  const factory MarketplaceCategory({
    required int id,
    required String name,
    required String slug,
    String? description,
    int? parentId,
    List<MarketplaceCategory>? children,
  }) = _MarketplaceCategory;
}
```

## API Endpoints

### WordPress REST API

- `GET /wp-json/aukrug/v1/marketplace/listings` - Anzeigen abrufen
- `POST /wp-json/aukrug/v1/marketplace/listings` - Anzeige erstellen
- `PUT /wp-json/aukrug/v1/marketplace/listings/{id}` - Anzeige bearbeiten
- `DELETE /wp-json/aukrug/v1/marketplace/listings/{id}` - Anzeige löschen
- `GET /wp-json/aukrug/v1/marketplace/categories` - Kategorien abrufen
- `POST /wp-json/aukrug/v1/marketplace/favorites/{id}` - Favorit hinzufügen/entfernen
- `POST /wp-json/aukrug/v1/marketplace/report/{id}` - Anzeige melden

## Screens & Navigation

### 1. MarketplaceListScreen

- **Route**: `/marketplace`
- **Funktion**: Hauptübersicht aller Anzeigen
- **Features**: Suche, Filter, Kategorien, Infinite Scroll

### 2. MarketplaceDetailScreen

- **Route**: `/marketplace/detail/{id}`
- **Funktion**: Detailansicht einer Anzeige
- **Features**: Bildergalerie, Kontakt-Options, Meldung, Owner-Aktionen

### 3. MarketplaceEditScreen

- **Route**: `/marketplace/edit/{id?}`
- **Funktion**: Anzeige erstellen oder bearbeiten
- **Features**: Formular-Validierung, Bild-Upload, Kategorie-Auswahl

### 4. MarketplaceMyListingsScreen

- **Route**: `/marketplace/my-listings`
- **Funktion**: Eigene Anzeigen verwalten
- **Features**: Status-Management, Statistiken, Bulk-Aktionen

### 5. MarketplaceVerificationScreen

- **Route**: `/marketplace/verification`
- **Funktion**: Benutzerverifizierung beantragen
- **Features**: Dokument-Upload, Status-Tracking

## Widgets & Komponenten

### MarketplaceListingCard

Wiederverwendbare Karte für Anzeigen-Darstellung in Listen.

### MarketplaceImageGallery

Full-Screen Bildergalerie mit Navigation und Zoom.

### MarketplaceSearchDelegate

Erweiterte Suchfunktionalität mit Vorschlägen und Filtern.

### MarketplaceFilterSheet

Bottom-Sheet für erweiterte Filter-Optionen.

### MarketplaceCategorySelector

Hierarchische Kategorie-Auswahl mit Radio-Buttons.

### MarketplaceImagePicker

Drag & Drop Bild-Upload mit Vorschau und Sortierung.

## State Management

Das System verwendet **Riverpod** für State Management:

```dart
// Repository Provider
final marketplaceRepositoryProvider = Provider<MarketplaceRepository>((ref) {
  return MarketplaceRepository(ref.read(marketplaceApiProvider));
});

// Listings Provider
final marketplaceListingsProvider = FutureProvider.family<List<MarketplaceListing>, MarketplaceFilters>((ref, filters) async {
  final repository = ref.read(marketplaceRepositoryProvider);
  return repository.getListings(filters: filters);
});

// Controller Provider
final marketplaceControllerProvider = StateNotifierProvider<MarketplaceController, MarketplaceState>((ref) {
  return MarketplaceController(ref.read(marketplaceRepositoryProvider));
});
```

## Sicherheitsfeatures

### Rate Limiting

```php
// WordPress Backend
private function check_rate_limits($user_id) {
    $today = date('Y-m-d');
    $create_count = get_user_meta($user_id, "marketplace_creates_$today", true);
    
    if ($create_count >= 5) {
        throw new Exception('Tageslimit für neue Anzeigen erreicht (5/Tag)');
    }
}
```

### EXIF Removal

```php
// Automatische EXIF-Entfernung bei Bild-Upload
private function remove_exif_data($image_path) {
    $image = imagecreatefromjpeg($image_path);
    imagejpeg($image, $image_path, 85);
    imagedestroy($image);
}
```

### Input Sanitization

```php
// WordPress Sanitization
$data = array(
    'title' => sanitize_text_field($request['title']),
    'description' => wp_kses_post($request['description']),
    'price' => floatval($request['price']),
);
```

## Installation & Setup

### WordPress Backend

1. Upload `class-aukrug-marketplace.php` zu `/wp-content/plugins/aukrug/includes/`
2. Upload `marketplace-admin.php` zu `/wp-content/plugins/aukrug/admin/`
3. Aktiviere das Plugin über WordPress Admin

### Flutter Frontend

1. Alle Dateien sind bereits im `/lib/features/marketplace/` Ordner
2. Imports sind in `marketplace.dart` verfügbar
3. Navigation-Routes in der Haupt-App registrieren

### Abhängigkeiten

```yaml
# pubspec.yaml
dependencies:
  flutter_riverpod: ^2.4.9
  freezed_annotation: ^2.4.1
  json_annotation: ^4.8.1
  dio: ^5.4.0
  image_picker: ^1.0.4
  photo_view: ^0.14.0
  share_plus: ^7.2.2

dev_dependencies:
  build_runner: ^2.4.7
  freezed: ^2.4.6
  json_serializable: ^6.7.1
```

## Nutzung

### Neue Anzeige erstellen

```dart
Navigator.of(context).pushNamed('/marketplace/edit');
```

### Anzeige anzeigen

```dart
Navigator.of(context).pushNamed('/marketplace/detail', arguments: listingId);
```

### Eigene Anzeigen verwalten

```dart
Navigator.of(context).pushNamed('/marketplace/my-listings');
```

## Erweiterungsmöglichkeiten

### 1. Push-Benachrichtigungen

- Neue Anzeigen in interessanten Kategorien
- Nachrichten von Interessenten
- Status-Updates für eigene Anzeigen

### 2. Chat-System

- Direkter Chat zwischen Käufer und Verkäufer
- Bild-Sharing im Chat
- Automatische Übersetzung

### 3. Zahlungsintegration

- Sichere Zahlungsabwicklung
- Escrow-Service für teure Artikel
- Gebühren-System für Unternehmen

### 4. Advanced Features

- KI-basierte Kategorie-Vorschläge
- Automatische Preis-Empfehlungen
- Duplikat-Erkennung
- Advanced Analytics

## Unterstützung

Bei Fragen oder Problemen:

1. Prüfe die Konsolen-Logs für Fehlermeldungen
2. Stelle sicher, dass alle Abhängigkeiten installiert sind
3. Überprüfe die WordPress REST API Endpunkte
4. Kontaktiere das Entwicklerteam für weitere Hilfe

## Changelog

### v1.0.0 (2024)

- ✅ Vollständiges Marketplace-System
- ✅ WordPress Backend mit REST API
- ✅ Flutter Frontend mit Riverpod
- ✅ Benutzerverifizierung
- ✅ DSGVO-konforme Implementierung
- ✅ Rate Limiting und Sicherheitsfeatures
- ✅ Responsive Design
- ✅ Offline-Support
