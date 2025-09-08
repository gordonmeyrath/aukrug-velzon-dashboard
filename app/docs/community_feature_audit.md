# Community Feature Audit (BuddyBoss-Parität Basis)

| Feature | Ist (App) | WP-API vorhanden? | Aufwand | Risiken | Abhängigkeiten | Flag-Key |
|---------|-----------|-------------------|---------|---------|----------------|----------|
| Profile (View/Edit) | rudimentär (statisch) | teilweise (User via auth lokal) | M | Mapping Backend-Felder, DSGVO Upload | Auth Gateway, Media Picker | FEATURE_PROFILE |
| Avatar/Cover Upload | nicht vorhanden | ggf. WP media endpoint | M | Datenschutz, Upload Fehler | Media Picker, Auth | FEATURE_PROFILE_MEDIA |
| Gruppen (List/Detail) | Basis Liste + Detail | public/custom? (noch offen) | M | Rechte/Rollen Mapping | Auth, Realtime | FEATURE_GROUPS |
| Gruppen Rollen/Join/Leave | nicht vorhanden | offen | M-L | Konsistenz, Race Conditions | Groups Grundmodell | FEATURE_GROUPS_ROLES |
| Aktivitäts-Feed Global | rudimentär (lokal) | offen (public api fehlt) | M-L | Paginierung, Moderation | Realtime, Auth | FEATURE_FEED |
| Feed: Like/Kommentar | nicht vorhanden | offen | M | Spam, Rate Limiting | Feed Basis | FEATURE_FEED_INTERACTIONS |
| Feed: Create Post Medien | nur Text | WP media | M | Upload Queue, Retry | Media Picker | FEATURE_FEED_MEDIA |
| Benachrichtigungen In-App | Dummy Liste | offen | M | Zustellgarantie | Notifications Gateway | FEATURE_NOTIFICATIONS |
| Push Notifications | nicht vorhanden | FCM Server nötig | L | Token Mgmt, Opt-In DSGVO | Notification Gateway | FEATURE_PUSH |
| Private Messages Threads | rudimentär | offen | M-L | Datenschutz, E2E? | Realtime, Auth | FEATURE_MESSAGES |
| Messages Attachments | nicht | media | M | Upload Handling | Messages Basis, Media Picker | FEATURE_MESSAGES_MEDIA |
| Events (Community) RSVP | Events (allgemein) | Events endpoint (teilweise) | M | Statuskonsistenz | Auth | FEATURE_EVENTS_RSVP |
| Events Kalender Export | nicht | ICS vorhanden | S | Timezone | Events Basis | FEATURE_EVENTS_ICS |
| Suche global | nicht | WP Search | M | Performance, Ranking | Gateways | FEATURE_SEARCH |
| Suche Scopes Users/Groups/Posts | nicht | mehrere Endpoints nötig | M-L | Aggregation | Search Basis | FEATURE_SEARCH_SCOPES |
| Moderation: Report/Block/Mute | nicht | offen | L | Missbrauch, Policy | Auth, Feed | FEATURE_MODERATION |
| Admin Badges | nicht | offen | S | Falsche Anzeige | Auth claims | FEATURE_ADMIN_BADGES |
| Membership/LMS Badges | nicht | offen | S | UI Fehlinfo | Auth claims | FEATURE_MEMBERSHIP_BADGES |
| Offline Cache Feeds | rudimentär Isar (Posts) | lokal | M | Konflikte, Merge | Isar Models | FEATURE_OFFLINE_FEED |
| Outbox/Retries Posts/DM | nicht | n/a | M | Duplikate | Realtime, Storage | FEATURE_OUTBOX |
| Realtime (SSE/WebSocket) | nicht | offen | M-L | Verbindungsabbrüche | Auth | FEATURE_REALTIME |
| Telemetrie Opt-In | nicht | n/a | S | DSGVO Fehler | A11y/Prefs | FEATURE_TELEMETRY |
| Barrierefreiheit Settings | nicht | n/a | S | UI Inkompatibilität | Theme Controller | FEATURE_A11Y |

Legende Aufwand: S (≤0.5d), M (0.5–2d), L (>2d)
