# API Inventory

Basis URL (geplant via .env): `API_BASE=https://aukrug.mioconnex.com`

## Aktuell genutzte / geplante Endpoints (WordPress Plugin)

| Endpoint | Methode | Auth | Beschreibung | Paging | Status |
|----------|---------|------|--------------|--------|--------|
| /aukrug/v1/health | GET | none | Health Check | - | Implementiert lokal |
| /aukrug/v1/places | GET | none | Orte (Geocache CPT) | ?page | Implementiert lokal |
| /aukrug/v1/places/{id} | GET | none | Ort Detail | - | Implementiert lokal |
| /aukrug/v1/events | GET | none | Veranstaltungen Liste | ?page | Implementiert lokal |
| /aukrug/v1/events/{id} | GET | none | Veranstaltung Detail | - | Implementiert lokal |
| /aukrug/v1/downloads | GET | none | Öffentliche Downloads | ?page | Implementiert lokal |
| /aukrug/v1/post-images/{id} | GET | none | Medien/Images eines Posts | - | Implementiert lokal |
| /wp/v2/media | POST | auth | Media Upload | - | Standard WP |
| /wp/v2/users/me | GET | auth | Aktueller User (Claims) | - | Standard WP |
| /wp/v2/search | GET | none | Generische Suche | page | Standard WP |

## Geplante Community/Realtime Endpoints (Entwurf)

| Endpoint | Methode | Auth | Beschreibung | Flag |
|----------|---------|------|--------------|------|
| /aukrug/v1/community/feed | GET | required | Feed Liste | FEATURE_FEED |
| /aukrug/v1/community/feed | POST | required | Post erstellen | FEATURE_FEED |
| /aukrug/v1/community/feed/{id}/like | POST | required | Like toggeln | FEATURE_FEED_INTERACTIONS |
| /aukrug/v1/community/feed/{id}/comment | POST | required | Kommentar anlegen | FEATURE_FEED_INTERACTIONS |
| /aukrug/v1/community/groups | GET | required | Gruppen Liste | FEATURE_GROUPS |
| /aukrug/v1/community/groups/{id} | GET | required | Gruppe Detail | FEATURE_GROUPS |
| /aukrug/v1/community/groups/{id}/join | POST | required | Gruppe beitreten | FEATURE_GROUPS_ROLES |
| /aukrug/v1/community/messages/threads | GET | required | Nachrichten Threads | FEATURE_MESSAGES |
| /aukrug/v1/community/messages/{peer} | GET | required | Thread Nachrichten | FEATURE_MESSAGES |
| /aukrug/v1/community/messages/{peer} | POST | required | Nachricht senden | FEATURE_MESSAGES |
| /aukrug/v1/community/notifications | GET | required | Notifications Liste | FEATURE_NOTIFICATIONS |
| /aukrug/v1/community/profile/{id} | GET | required | Profil anzeigen | FEATURE_PROFILE |
| /aukrug/v1/community/profile/{id} | PATCH | required | Profil ändern | FEATURE_PROFILE |
| /aukrug/v1/community/search | GET | required | Multi-Scope Suche | FEATURE_SEARCH |
| /aukrug/v1/community/moderation/report | POST | required | Inhalt melden | FEATURE_MODERATION |

Hinweis: Auth Refresh / Bearer Tokens noch zu spezifizieren.
