# Aukrug Connect (WordPress Plugin)

A modular plugin providing:

- Custom post types + taxonomies
- Delta sync + tombstones endpoints
- Private reports with photo EXIF stripping
- E2EE device registry (/devices, /identities)
- Push relay with rate limiting and provider selection (FCM, APNs, Web Push)

## Setup

1. Install plugin (wrapper is `wpaukrug/wpaukrug.php` which loads this internal plugin).
2. In WP Admin → Settings → Aukrug Connect, configure:
   - Push Provider: `fcm`, `apns`, or `webpush`.
   - FCM: `au_fcm_server_key`.
   - APNs: `au_apns_team_id`, `au_apns_key_id`, `au_apns_topic`, `au_apns_p8`, `au_apns_sandbox`.
   - Web Push: `au_vapid_public`, `au_vapid_private`, `au_vapid_subject`.
   - Rate limits: `au_rate_limit_count`, `au_rate_limit_window`.

## Web Push

- Clients may GET `/wp-json/aukrug-connect/v1/vapid` to obtain `{ publicKey, subject }`.
- For encrypted delivery, install the optional library:

```sh
composer require minishlink/web-push
```

- Without the library, the plugin will not attempt non-standard unencrypted sends (disabled by default).

## Development

- Autoload via Composer (classmap `includes/`). Fallback autoloader maps core classes when Composer isn’t present.
- Tests (optional):

```sh
composer install
vendor/bin/phpunit -c tests/phpunit.xml --testdox
```

## Endpoints (partial)

- GET `/delta`, GET `/tombstones`
- POST `/reports` (auth)
- POST `/devices` (auth), GET `/identities` (auth)
- GET `/vapid` (public)
- POST `/relay` (auth)
