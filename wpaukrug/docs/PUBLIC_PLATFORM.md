# Öffentliche Meldungsplattform - Gemeinde Aukrug

## Übersicht

Die öffentliche Meldungsplattform ermöglicht es Bürgern der Gemeinde Aukrug, Probleme und Anliegen direkt an die Gemeindeverwaltung zu melden und den Bearbeitungsstatus transparent zu verfolgen.

## Features

### 🏛️ Für Bürger

- **Einfache Meldung**: Schnelle Erfassung von Problemen über ein benutzerfreundliches Formular
- **Transparente Verfolgung**: Einsicht in den Bearbeitungsstatus aller Meldungen
- **Direkte Kommunikation**: Möglichkeit für Rückfragen und zusätzliche Informationen
- **Kategorisierte Meldungen**: 12 verschiedene Kategorien (Straße, Beleuchtung, Abfall, etc.)

### 🔧 Für die Verwaltung

- **Zentrale Übersicht**: Dashboard mit allen eingehenden Meldungen
- **Workflow-Management**: Status-Verfolgung von "Eingegangen" bis "Abgeschlossen"
- **Bulk-Operationen**: Effiziente Bearbeitung mehrerer Meldungen
- **E-Mail-Benachrichtigungen**: Automatische Updates bei Statusänderungen
- **Reporting & Statistiken**: Zeitreihen-Analysen und Export-Funktionen

## Implementierte Komponenten

### Backend (WordPress Plugin)

1. **Database Schema** (`class-aukrug-database.php`)
   - Erweiterte Tabellen für Kommentare und Aktivitäten
   - Versionierte Migrations-Unterstützung

2. **REST API** (`class-aukrug-rest.php`)
   - Vollständige CRUD-Operationen für Meldungen
   - Kommentar-System mit öffentlicher/privater Sichtbarkeit
   - Bulk-Operationen und Export-Funktionen
   - Rate Limiting gegen Spam

3. **Notification System** (`class-aukrug-notifications.php`)
   - HTML E-Mail-Templates
   - Automatische Benachrichtigungen bei Status-Änderungen
   - Admin- und Bürgerkommunikation

4. **Public Interface** (`class-aukrug-public-reports.php`)
   - Öffentliche Meldungsformulare (Shortcodes)
   - Meldungsdetail-Ansichten
   - Öffentliche URL-Struktur (`/meldung/{id}`)

5. **Admin Dashboard** (`admin/dashboard-page.php`)
   - Moderne Verwaltungsoberfläche
   - Erweiterte Filter- und Suchfunktionen
   - Zeitreihen-Visualisierungen
   - Modal-Dialog für Meldungsdetails

### Frontend Features

1. **Responsive Design**: Optimiert für Desktop und Mobile
2. **Real-time Updates**: AJAX-basierte Aktualisierungen
3. **Barrierefreiheit**: Semantic HTML und ARIA-Labels
4. **Performance**: Optimierte Datenbankabfragen und Caching

## Kategorien

Die Plattform unterstützt folgende Meldungskategorien:

- 🛣️ **Straße & Verkehr**: Schlaglöcher, defekte Schilder, Markierungen
- 💡 **Beleuchtung**: Defekte Straßenlaternen, dunkle Bereiche
- 🗑️ **Abfall & Entsorgung**: Wilde Müllablagerung, volle Container
- 🏗️ **Vandalismus**: Sachschäden an öffentlichem Eigentum
- 🌳 **Grünflächen & Parks**: Pflege von Parks, umgestürzte Bäume
- 🚰 **Wasser & Abwasser**: Wasserrohrbrüche, verstopfte Gullys
- 🔊 **Lärm & Ruhestörung**: Lärmbelästigung, Ruhestörungen
- 🎮 **Spielplätze**: Defekte Geräte, Sicherheitsprobleme
- 🌱 **Umwelt & Natur**: Umweltverschmutzung, Naturschutz
- ❄️ **Winterdienst**: Räumung, Streudienst
- 🏢 **Öffentliche Gebäude**: Schäden an Gemeindegebäuden
- 📋 **Sonstiges**: Alle anderen Anliegen

## Status-Workflow

1. **Eingegangen** (`open`): Neue Meldung wurde erstellt
2. **In Bearbeitung** (`in_progress`): Verwaltung bearbeitet das Problem
3. **Gelöst** (`resolved`): Problem wurde behoben
4. **Abgeschlossen** (`closed`): Vorgang vollständig abgeschlossen

## Technische Details

### Rate Limiting

- **Meldungen**: 3 pro 5 Minuten pro IP-Adresse
- **Kommentare**: 5 pro 5 Minuten pro IP-Adresse

### E-Mail-Benachrichtigungen

- Neue Meldung an Verwaltung
- Status-Updates an Melder
- Neue Kommentare an beide Parteien
- Zuweisungs-Benachrichtigungen an Bearbeiter

### Datenschutz & Sicherheit

- DSGVO-konforme Datenverarbeitung
- Nonce-Validierung für alle Formulare
- IP-basiertes Rate Limiting
- Sanitized Input/Output

## Installation & Verwendung

### Shortcodes

```php
// Meldeformular einbetten
[aukrug_report_form]

// Liste aller Meldungen anzeigen
[aukrug_reports_list limit="10" status="all" category="all"]

// Einzelne Meldung anzeigen
[aukrug_report_view id="123"]
```

### URL-Struktur

- **Einzelne Meldung**: `/meldung/{id}`
- **Meldungsübersicht**: `/meldungen/`
- **Neue Meldung**: `/meldung-erstellen/`

### Demo

Eine vollständige Demo der öffentlichen Funktionalität finden Sie in:

- `public/demo.html` - Interaktive Demonstration
- `public/index.html` - Startseite mit Features

## API Endpoints

### Public Endpoints

- `POST /wp-json/aukrug/v1/reports` - Neue Meldung erstellen
- `GET /wp-json/aukrug/v1/reports` - Öffentliche Meldungen abrufen
- `POST /wp-json/aukrug/v1/reports/{id}/comments` - Kommentar hinzufügen

### Admin Endpoints (authentifiziert)

- `PUT /wp-json/aukrug/v1/reports/{id}` - Meldung aktualisieren
- `DELETE /wp-json/aukrug/v1/reports/{id}` - Meldung löschen
- `POST /wp-json/aukrug/v1/reports/bulk-update` - Bulk-Operationen
- `GET /wp-json/aukrug/v1/reports/export` - CSV-Export
- `GET /wp-json/aukrug/v1/reports/timeseries` - Statistiken

## Nächste Schritte

1. **App-Integration**: Mobile App für iOS/Android
2. **Foto-Upload**: Bilder zu Meldungen hinzufügen
3. **Karten-Integration**: Geografische Darstellung der Meldungen
4. **Push-Benachrichtigungen**: Real-time Updates für die App
5. **Erweiterte Analysen**: Detaillierte Berichte und Trends

## Support

Bei Fragen oder Problemen wenden Sie sich an die Gemeindeverwaltung Aukrug oder den technischen Support.
