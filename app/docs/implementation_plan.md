# Implementation Plan BuddyBoss-Parität (App Seite)

## Leitprinzipien

- Additiv, keine Breaking Changes
- Alles hinter Feature Flags (default OFF)
- Community nur für verifizierte authentifizierte User mit Claim `canAccessCommunity`

## Meilensteine

1. Audit & Planung (DONE)
2. Core Infrastruktur (AuthGateway, NotificationGateway, RealtimeClient, MediaPickerService, A11yPrefs, ThemeController, FeatureFlags)
3. Community Gate + Navigation Gating
4. Profile & Gruppen Grundfunktion (Read-only) + Feed Read
5. Feed Interaktionen (Create, Like, Kommentieren) + Outbox/Offline
6. Messages Threads & Chat + Attachments
7. Notifications (In-App + Push) + Suche
8. Moderation & Reporting + Admin Badges
9. Events RSVP + ICS Export + Calendar Integration
10. A11y & Telemetrie Opt-In + Export/Löschung End2End Test
11. Tests, CI Skript, Doku, Demo Recording

## Feature Flags (.env / runtime)

```
FEATURE_PROFILE=false
FEATURE_PROFILE_MEDIA=false
FEATURE_GROUPS=false
FEATURE_GROUPS_ROLES=false
FEATURE_FEED=false
FEATURE_FEED_INTERACTIONS=false
FEATURE_FEED_MEDIA=false
FEATURE_NOTIFICATIONS=false
FEATURE_PUSH=false
FEATURE_MESSAGES=false
FEATURE_MESSAGES_MEDIA=false
FEATURE_EVENTS_RSVP=false
FEATURE_EVENTS_ICS=false
FEATURE_SEARCH=false
FEATURE_SEARCH_SCOPES=false
FEATURE_MODERATION=false
FEATURE_ADMIN_BADGES=false
FEATURE_MEMBERSHIP_BADGES=false
FEATURE_OFFLINE_FEED=false
FEATURE_OUTBOX=false
FEATURE_REALTIME=false
FEATURE_TELEMETRY=false
FEATURE_A11Y=false
```

## Datenflüsse

- AuthGateway verwaltet Access/Refresh Tokens & Claims (inkl. canAccessCommunity)
- Gateways (Feed, Groups, Messages) nutzen Dio Client mit Interceptor (401→Login redirect)
- RealtimeClient broadcastet Events (post_created, message_received)
- Offline: Isar Collections (posts, messages, outbox)

## Sicherheits-/DSGVO Punkte

- Opt-In Telemetrie vor Senden
- Export/Löschung über AuthGateway delegiert
- Keine PII in Logs/Outbox

## Migrationsnotizen

- Bestehende Providers unverändert lassen, neue Namespaces `core/*` + `features/community_ext/*`
- Alte Fake-Daten sukzessive ersetzen sobald Backend bereit

## Tests

- Unit: AuthGateway, FeatureFlags, CommunityGate
- Widget: FeedList (Flag an/aus), CommunityTabVisibility
- Integration: Login→Claim→Freischaltung

## Offene Fragen / To Clarify

- Backend Token Format (JWT?)
- Rate Limits für Feed/Chat
- Mediengrößen & Transcoding

