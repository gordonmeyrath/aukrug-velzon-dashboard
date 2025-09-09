# Aukrug Workspace - Analyse & Architektur

## Übersicht

Mono-Workspace mit Flutter-App, WordPress-Plugin und Node.js-Backend für die Aukrug-Plattform.

## Flutter App (`/app`)

### Hauptfunktionen
- **Benutzeranmeldung**: JWT-basierte Authentifizierung
- **Marktplatz**: Anzeigen von Listings (draft → active → sold)
- **Item-Management**: CRUD-Operationen für Benutzer-Items
- **Profilverwaltung**: Benutzerdaten und Einstellungen

### Modelle
```dart
class User {
  String id, email, name, role;
  DateTime createdAt, updatedAt;
}

class Item {
  String id, title, description, ownerId;
  bool isDemo;
  DateTime createdAt, updatedAt;
}

class Listing {
  String id, title, description, ownerId, status;
  double? price;
  bool isDemo;
  DateTime createdAt, updatedAt;
}
```

### API-Endpunkte
- `POST /api/auth/register` - Registrierung
- `POST /api/auth/login` - Anmeldung
- `POST /api/auth/refresh` - Token erneuern
- `GET /api/items` - Items auflisten
- `POST /api/items` - Item erstellen
- `GET /api/marketplace/listings` - Listings auflisten
- `POST /api/marketplace/listings` - Listing erstellen

## WordPress Plugin (`/plugin`)

### Integration
- **Shortcodes**: `[aukrug-listings]`, `[aukrug-user-items]`
- **Admin-Panel**: Backend-Konfiguration, API-Einstellungen
- **REST-API Integration**: Kommunikation mit Node.js-Backend

### Rollen & Berechtigungen
- **Visitor**: Listings ansehen
- **Member**: Items verwalten, Listings erstellen
- **Admin**: Vollzugriff, Demo-Daten verwalten

## Backend API (`/api`)

### Technologie-Stack
- **Runtime**: Node.js 18+
- **Framework**: Express.js + TypeScript
- **Database**: MariaDB/MySQL mit Prisma ORM
- **Auth**: JWT (Access + Refresh Tokens)
- **Validation**: Zod Schema Validation
- **Documentation**: OpenAPI 3.1

### Sicherheitsregeln
1. **Rate Limiting**: 100 Requests/15min pro IP
2. **CORS**: Konfigurierbare Origins
3. **Input Validation**: Strict Zod-Schema
4. **Authentication**: JWT Bearer Token required
5. **Authorization**: Role-based Access (user/admin)

### Datenbank-Regeln
- **Soft Delete**: Items/Listings werden archiviert, nicht gelöscht
- **Demo Data**: `isDemo=true` für Test-Daten
- **Ownership**: Nutzer können nur eigene Ressourcen bearbeiten
- **Admin Override**: Admins haben Vollzugriff

## Development Workflow

1. **Local**: Flutter-App entwickeln
2. **Remote**: Backend in LXC testen
3. **Sync**: Git-Repos zwischen GitHub ↔ Forgejo
4. **Deploy**: Systemd-Service + Nginx Reverse-Proxy

## Umgebungen

- **Development**: `NODE_ENV=development`, Swagger-Docs aktiv
- **Production**: `NODE_ENV=production`, nur Health-Check
- **Demo**: Seeds mit `isDemo=true`, purge via `npm run purge-demo`
