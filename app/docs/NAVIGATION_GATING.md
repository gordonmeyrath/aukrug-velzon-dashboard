# Navigation & Feature Gating

Dieses Dokument beschreibt die Implementierung der Navigations- und Feature-Gating-Logik (Stand: September 2025).

## Ziele

- Einheitliche AppShell für alle Audiences
- Dynamisches Ein-/Ausblenden des Community-Tabs per Feature Flag + Auth
- Freundlicher Fallback statt harter Redirects
- Zentrale Navigation-Definition

## Komponenten

| Bereich | Datei | Zweck |
|--------|-------|-------|
| Feature Flags | core/config/feature_flags.dart | Laden der FEATURE_* Variablen |
| Permission Provider | features/auth/data/permissions.dart | Logik: canAccessCommunity |
| Guard | router/guards/community_guard.dart | Redirect-Entscheidung |
| Navigation Config | shared/navigation/navigation_config.dart | Definition aller Tabs |
| Locked Page | features/community/presentation/pages/community_locked_page.dart | Nutzerhinweis |
| AppShell | shared/widgets/app_shell.dart | Dynamische BottomNavigation |
| Drawer | shared/widgets/app_navigation_drawer.dart | Ausblendung Community-Eintrag |

## Ablauf

1. Nutzer ruft /community/* auf
2. Guard prüft Provider
3. Falls blockiert -> /community/locked
4. Seite bietet CTA zur Anmeldung
5. Nach Auth + Flag wieder regulärer Zugriff

## Erweiterung

- Zusätzliche Rollen über weitere Provider
- Remote Flag Overrides möglich

## Nächste Schritte

- Tests (Unit + Widget) für Guard & Navigation
- Analytics-Ereignis bei Blockierung (optional)
