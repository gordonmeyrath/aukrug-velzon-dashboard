# Milestone: Community offline-first (v0.9.1)

Datum: 2025-09-05

Ziel

- Community-Daten offline-fähig (Isar), Cache-first-Reads, optimistische Writes.
- Detailseiten für Gruppen & Chat, manuelles Refresh, echte User-ID statt Platzhalter.

Ergebnis (erledigt)

- Isar-Cache & Local Repository: Users, Groups, Posts, Messages inkl. Upsert/Get.
- Provider (Riverpod):
  - Cache-first: usersProvider, groupsProvider, feedProvider, messagesProvider.
  - Refresh: refreshUsersProvider, refreshGroupsProvider, refreshFeedProvider, refreshMessagesProvider (force fetch → upsert → invalidate).
  - Selektoren: groupByIdProvider, chatByPeerProvider.
  - Optimistisch: createPostControllerProvider, sendMessageControllerProvider.
- UI/Navigation:
  - Feed/Groups/Messages mit Pull-to-Refresh.
  - GroupDetailPage & ChatDetailPage, Routing verdrahtet.
  - Composer (Feed/Chat) nutzt aktuelle User-ID (Fallback ‘anonymous’).

Qualität

- Tests: grün (Widget-Overflow im Audience Picker behoben durch Scroll-Layout).
- Analyzer: nur bestehende Infos/Deprecations (z. B. withOpacity, generierte Riverpod-Typen).

Relevante Dateien

- lib/features/community/application/providers.dart
- lib/features/community/presentation/pages/{feed_page.dart,groups_page.dart,messages_page.dart,chat_detail_page.dart}
- lib/features/shell/presentation/audience_picker_page.dart (Overflow-Fix)

Offene Punkte

- withOpacity schrittweise ersetzen (.withValues()/Alpha-Farben) in häufigen Views (Home, Map, Documents, Auth, …).
- Optional: Pull-to-Refresh für GroupDetailPage und Chat-Thread; “Zuletzt aktualisiert”-Hint (Timestamp nach Upsert).
- Auth-Integration schärfen: Fallback ‘anonymous’ definieren/Composer ggf. sperren, wenn kein User.
- Offline-/Fehler-UX: Banner, Retry, leere Zustände.
- Deprecations reduzieren (Analyzer/Riverpod-Generates aktualisieren).

Wie verifizieren

- App → Community → Feed/Groups/Messages: Pull-to-Refresh lädt Fixtures, cached in Isar, UI aktualisiert.
- Post/Message erstellen: erscheint sofort (optimistisch), Daten werden im Hintergrund gespiegelt.

Nächste Schritte

1) withOpacity-Bereinigung in Hotspots fortsetzen.
2) “Zuletzt aktualisiert” pro Liste anzeigen (Repo-/Isar-Write-Timestamp).
3) Chat-Thread: Pull-to-Refresh + “als gelesen markieren”.
4) Fehler-/Offline-Handling (Banner + Retry) ergänzen.
