# Aukrug Workspace Context

## Vision

The Aukrug project provides a digital platform for the Aukrug municipality, serving both tourists and residents with location-based information, services, and community features.

## Requirements Summary

- **Split**: Tourist (public) vs Resident (login/opt-in) roots
- **Backend**: WordPress plugin "aukrug-connect", REST /wp-json/aukrug/v1
- **Features**: places, routes (GPX/GeoJSON), events, notices (warn/info), downloads (Kita/Schule PDFs), reports (Mängelmelder), providers (Gastro/Handwerk)
- **Map**: OSM (flutter_map), near-me, clustering; offline tiles optional later
- **Offline-first**: local cache (hive|isar), ETag + If-Modified-Since, delta sync /sync/changes
- **Push (later)**: FCM/APNs prepared
- **DSGVO**: EU hosting, data minimization, consent screen (analytics off by default), no children photos, no PII in app store, export/delete rights
- **Kita/Schule**: Öffnungszeiten, Schließ-/Ferientage, Essensplan, Elternbriefe (protected), Kalender-Export (ICS), keine personenbezogenen Daten
- **CI**: Flutter analyze/test/build; PHP phpcs/phpunit
- **Backups**: tool/backup.sh → backups/aukrug_workspace_<commit>_<timestamp>.zip
- **Monorepo**: Forgejo primary (origin), GitHub private (backup)

## Core Concepts

### Target Audiences

**Tourists**
- Public access to places, routes, events
- No registration required for basic features
- Focus on discovery and navigation
- Multilingual support (DE/EN primary)

**Residents**
- Extended features requiring authentication
- Community reports and feedback
- Private notices and local services
- KITA/School specific information

### Technical Architecture

**Offline-First Design**
- Core functionality works without internet
- Delta synchronization for updates
- Local storage with Hive/Isar
- Progressive enhancement for online features

**Privacy by Design (DSGVO)**
- Minimal data collection
- No tracking of children under 16
- Clear consent flows
- Data export/deletion capabilities
- Audit logging for sensitive operations

### Data Categories

**Places**: POIs, businesses, public facilities
**Routes**: Walking/cycling paths, tour recommendations  
**Events**: Public events, festivals, meetings
**Notices**: Official announcements, alerts
**Downloads**: Documents, maps, guides
**Reports**: Community feedback, issue reporting
**Providers**: Gastronomy and crafts businesses

## Integration Points

- **WordPress REST API**: `/wp-json/aukrug/v1/*`
- **Delta Sync**: ETag/Last-Modified headers for efficient updates
- **JWT Authentication**: For resident-only features
- **Media Handling**: Optimized images, offline caching

## Compliance Notes

- GDPR/DSGVO compliant data handling
- No personal data of minors without explicit consent
- Regular data audits and cleanup procedures
- Privacy-first architecture design
