# Marketplace System Documentation

## Overview

Das Aukrug Marketplace System ermöglicht verifizierten Benutzern das Erstellen, Verwalten und Durchsuchen von Kleinanzeigen mit strengen DSGVO-Compliance und Anti-Missbrauch-Maßnahmen.

## Features

### Core Functionality

- **Listings Management**: CRUD-Operationen für Kleinanzeigen
- **User Verification**: Zweistufiges Verifikationssystem (Resident/Business)
- **Categories**: Hierarchische Kategorisierung
- **Image Upload**: EXIF-Stripping und Kompression
- **Favorites**: Benutzer können Anzeigen favorisieren
- **Search & Filter**: Volltext, Kategorie, Preis, Bereich
- **Moderation**: Report-System und Admin-Tools

### Security Features

- **Rate Limiting**: 5 Anzeigen/Tag, 20 Bearbeitungen/Tag
- **Verification Gates**: Nur verifizierte Benutzer können Anzeigen erstellen
- **EXIF Stripping**: Automatische Entfernung von Metadaten
- **Content Moderation**: Report-System und Admin-Übersicht
- **Data Minimization**: Keine genauen GPS-Koordinaten, nur grobe Bereiche

## Database Schema

### Custom Post Type: market_listing

```php
'post_type' => 'market_listing'
'supports' => ['title', 'editor', 'author', 'thumbnail', 'custom-fields']
```

#### Meta Fields:

- `price` (number): Preis in der gewählten Währung
- `currency` (string): Währung (default: EUR)
- `location_area` (string): Grober Bereichsname (kein GPS)
- `images` (array): Array von Attachment IDs
- `status` (enum): active|paused|sold
- `contact_via_messenger` (boolean): Kontakt über Messenger erlaubt

### Taxonomy: market_category

```php
'taxonomy' => 'market_category'
'hierarchical' => true
```

### User Meta Fields

- `au_verified_resident` (boolean): Resident-Verifikation
- `au_verified_business` (boolean): Business-Verifikation  
- `au_verification_pending` (array): Ausstehende Verifikationsanfrage
- `au_verification_note` (string): Admin-Notizen zur Verifikation
- `au_fav_listings` (array): Favorisierte Listings
- `au_rate_limit_create_YYYY-MM-DD` (number): Tägliche Erstellungslimits
- `au_rate_limit_edit_YYYY-MM-DD` (number): Tägliche Bearbeitungslimits

## REST API Endpoints

### Base URL: `/wp-json/aukrug/v1/market/`

#### Listings

- **GET** `/listings` - Liste aller Anzeigen
  - Query-Parameter: search, category, price_min, price_max, area, status, page, per_page, sort
- **POST** `/listings` - Neue Anzeige erstellen (Auth + Verification required)
- **GET** `/listings/{id}` - Einzelne Anzeige abrufen
- **PUT** `/listings/{id}` - Anzeige bearbeiten (Owner + Verification required)
- **DELETE** `/listings/{id}` - Anzeige löschen (Owner or Moderator)

#### Status Management

- **POST** `/listings/{id}/status` - Status ändern (pause/sold/reactivate)

#### Favorites

- **POST** `/favorites/{id}` - Favorit toggle (Auth required)
- **GET** `/favorites` - Benutzer-Favoriten abrufen (Auth required)

#### Reporting

- **POST** `/listings/{id}/report` - Anzeige melden (Auth required)

#### Image Upload

- **POST** `/upload` - Bild hochladen mit EXIF-Stripping (Auth required)

### Verification Endpoints: `/wp-json/aukrug/v1/verification/`

- **POST** `/request` - Verifikation beantragen (Auth required)
- **GET** `/status` - Verifikationsstatus abrufen (Auth required)

## Permission System

### Capabilities

- `read_marketplace`: Anzeigen lesen
- `edit_marketplace`: Eigene Anzeigen bearbeiten
- `moderate_marketplace`: Alle Anzeigen moderieren

### Verification Requirements

- **Anzeigen erstellen**: Requires `au_verified_resident` OR `au_verified_business`
- **Anzeigen bearbeiten**: Owner + Rate Limits OR `moderate_marketplace`
- **Anzeigen löschen**: Owner OR `moderate_marketplace`

### Rate Limits

- **Erstellung**: 5 Anzeigen pro Tag
- **Bearbeitung**: 20 Bearbeitungen pro Tag
- **Implementation**: User Meta mit täglicher Zurücksetzung

## Admin Interface

### Navigation: Admin → Aukrug → Marketplace

#### Tabs:

1. **Listings**: Übersicht, Filter, Bulk-Aktionen
2. **Categories**: CRUD für Kategorien
3. **Verification**: Ausstehende Verifikationsanträge
4. **Reports**: Missbrauchsmeldungen verwalten
5. **Settings**: Rate Limits, Moderation, Benachrichtigungen

#### Verification Workflow:

1. Benutzer sendet Antrag mit Name, Adresse
2. Admin überprüft in Verification-Tab
3. Approve/Reject → Benutzer-Meta wird gesetzt + E-Mail
4. Benutzer kann dann Anzeigen erstellen

## DSGVO Compliance

### Data Minimization

- **Keine GPS-Koordinaten**: Nur grober Bereichsname gespeichert
- **EXIF-Stripping**: Automatische Metadaten-Entfernung
- **Lokale Distanzberechnung**: GPS nur client-side für Entfernungsfilter

### Right to Erasure

- **Benutzer können eigene Anzeigen löschen**
- **Admin kann alle Daten löschen**
- **Bilder werden mit Anzeige gelöscht**

### Consent Management

- **Marketplace-Nutzung**: Expliziter Consent bei erster Nutzung
- **Community-Sichtbarkeit**: Separate Einwilligung für Feed-Integration

## Community Integration

### Feed Integration

- **Hook**: `au_comm_feed_add` wird bei Veröffentlichung gefeuert
- **Payload**: Titel, Bild, Preis, Deep Link
- **Endpoint**: `GET /community/feed?include=market` für gemischte Feeds

### Server-side Event

```php
do_action('au_comm_feed_add', [
    'type' => 'marketplace_listing',
    'title' => $post_title,
    'content' => $excerpt,
    'image' => $first_image_url,
    'price' => $price,
    'currency' => $currency,
    'deep_link' => "/marketplace/{$post_id}",
    'created_at' => $post_date
]);
```

## Security Measures

### Anti-Abuse

- **Rate Limiting**: Verhindert Spam
- **Verification Gates**: Nur verifizierte Benutzer
- **Report System**: Community-Moderation
- **Admin Notification**: E-Mail bei neuen Reports

### Content Security

- **EXIF Stripping**: Entfernt persönliche Metadaten
- **Image Compression**: Reduziert Dateigröße
- **Content Sanitization**: wp_kses_post für Beschreibungen
- **Input Validation**: Alle Parameter werden sanitized

### Privacy Protection

- **Kein direkter Kontakt**: Nur über E2EE Messenger
- **Anonyme Reports**: Reporter-ID nur für Admins sichtbar
- **Coarse Location**: Keine exakten Adressen in API

## Testing

### PHPUnit Tests

Erstelle Tests für:

- CRUD Operations
- Permission Checks
- Rate Limiting
- Verification Flow
- EXIF Stripping
- Security Validation

### Test Structure

```
/wpaukrug/tests/marketplace/
├── test-marketplace-crud.php
├── test-verification.php
├── test-permissions.php
├── test-rate-limits.php
└── test-security.php
```

## Configuration

### Settings (via Admin UI)

- **Rate Limits**: Anpassbare Tageslimits
- **Moderation**: Auto-Publish, Image Requirements
- **Notifications**: Admin E-Mail Einstellungen
- **EXIF Stripping**: Ein/Aus (empfohlen: An)

### Feature Flags

- `MARKETPLACE_ENABLED`: Master-Switch für gesamtes System
- `MARKETPLACE_AUTO_PUBLISH`: Automatische Veröffentlichung
- `MARKETPLACE_REQUIRE_IMAGE`: Mindestens ein Bild erforderlich

## Troubleshooting

### Common Issues

1. **Verification nicht möglich**: Prüfe User Meta und Admin-Rechte
2. **Rate Limit erreicht**: Meta-Keys für aktuellen Tag prüfen  
3. **Bilder nicht hochgeladen**: WordPress Media-Rechte prüfen
4. **EXIF nicht entfernt**: wp_get_image_editor Support prüfen

### Debug Logging

```php
// Enable in wp-config.php
define('AUKRUG_MARKETPLACE_DEBUG', true);

// Logs in: /wp-content/debug.log
error_log('Aukrug Marketplace: ' . $message);
```

## Performance Optimization

### Caching

- **Listings Query**: WP Object Cache für häufige Suchen
- **Category Terms**: Persistent Caching der Taxonomie
- **User Verification**: Cache Verification Status

### Database Optimization

- **Indexes**: Meta-Keys für price, status, location_area
- **Pagination**: Immer mit Limits arbeiten
- **Cleanup**: Regelmäßige Bereinigung alter Rate-Limit-Daten

## Integration Examples

### Theme Integration

```php
// Marketplace Shortcode
echo do_shortcode('[aukrug_marketplace category="electronics" limit="6"]');

// Recent Listings Widget
$recent = aukrug_get_recent_listings(5);
foreach ($recent as $listing) {
    echo aukrug_format_listing_card($listing);
}
```

### Custom Queries

```php
// Get user's active listings
$user_listings = get_posts([
    'post_type' => 'market_listing',
    'author' => $user_id,
    'meta_query' => [
        ['key' => 'status', 'value' => 'active']
    ]
]);
```
