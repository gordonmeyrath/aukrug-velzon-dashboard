# API SPEC — Step 2 (Delta Sync)

Base namespace: `/wp-json/aukrug-connect/v1`

## GET /delta

- Query params:
  - `since` (ISO datetime, optional)
  - `limit` (int, default 200, max 500)

- Response:

```
{
 "items": [
  {
   "id": 123,
   "entity_type": "au_place",
   "entity_id": "456",
   "action": "created|updated|deleted",
   "payload": null,
   "user_id": 1,
   "created_at": "2025-09-05 08:15:00"
  }
 ],
 "next": "2025-09-05 08:15:00"
}
```

## GET /tombstones

- Query params:
  - `since` (ISO datetime, optional)
  - `limit` (int, default 200, max 500)

- Response:

```
{
 "items": [
  {
   "id": 12,
   "entity_type": "au_place",
   "entity_id": "456",
   "deleted_at": "2025-09-05 08:16:00"
  }
 ],
 "next": "2025-09-05 08:16:00"
}
```

- `payload` is reserved for future enriched snapshots.
- All timestamps are UTC.
- Entities covered: au_place, au_route, au_event, au_notice, au_download, au_provider, au_group, au_community_post.

## Step 3 — E2EE Device Registry

Base namespace: `/wp-json/aukrug-connect/v1`

### POST /devices (auth required)

- Body (JSON or form):
  - `device_id` (string, required)
  - `public_identity` (string, required; client public data for E2EE)
  - `push_token` (string, optional)
  - `platform` (string, optional; e.g., ios|android|web)
- Response: `{ "ok": true }`

### GET /identities (auth required)

- Query:
  - `user_ids` (array of integers)

- Response:

```
{
  "items": [
    { "user_id": 1, "device_id": "abc", "public_identity": "...", "push_token": "...", "platform": "ios" }
  ]
}
```

Notes:

- No message content is stored server-side. Only device registry and public identity material.
- Use identities for addressing and push fanout; messages should be E2EE and relayed client-to-client via push.

### GET /vapid

- Public endpoint to fetch Web Push VAPID configuration for clients to subscribe.
- Response:

```
{ "publicKey": "<base64url>", "subject": "mailto:admin@example.com" }
```

## Step 4 — Relay (Push Fanout)

Base namespace: `/wp-json/aukrug-connect/v1`

### POST /relay (auth required)

  - `target_user_ids` (array of integers, required)
  - `notification` (object, optional; e.g., `{ "title": "...", "body": "..." }`)
  - `data` (object, optional; key-value map of strings)


```
{ "ok": true, "delivered": 2 }
```

Rate limiting:

- Per-user sliding window via WordPress transients.
- Defaults: 60 requests per 300 seconds.
- Configurable in Settings.

Providers:

- FCM via server key.
- APNs (JWT/ES256). Requires: Team ID, Key ID, .p8 private key, Topic (bundle ID), and sandbox toggle.
- Web Push (VAPID). Requires: VAPID public/private keys and subject; client must register subscriptions (endpoint + keys).

Privacy:

- No message content is stored; only relayed to registered device tokens.

## Step 5 — Settings

Location: WP Admin → Settings → Aukrug Connect

Options:

- `au_fcm_server_key` (string): FCM server key used by relay.
- `au_rate_limit_count` (int): Max relay requests per window (default 60).
- `au_rate_limit_window` (int, seconds): Window duration (default 300).
- `au_push_provider` (string): `fcm` (default), `apns`, or `webpush`.
- `au_apns_team_id`, `au_apns_key_id`, `au_apns_topic`, `au_apns_p8`, `au_apns_sandbox`.
- `au_vapid_public`, `au_vapid_private`, `au_vapid_subject`.

## Downloads API

Base namespace: `/wp-json/aukrug-connect/v1`

### GET /downloads

- Query params:
  - `search` (string, optional)
  - `category` (string slug, optional)
  - `popular` (boolean, optional)
  - `limit` (int, default 50, max 100), `offset` (int, default 0)

- Response:

```
{ "items": [
  { "id": 1, "title": "…", "excerpt": "…", "url": "…", "requires_auth": false,
    "popular": true, "size": 123456, "categories": ["taxes"], "updated_at": "2025-09-05T12:00:00Z" }
], "total": 10 }
```

### GET /download-categories

- Response: `{ "items": [ { "id": 1, "slug": "taxes", "name": "Steuern", "count": 3 } ] }`

### GET /download

- Query: `id` (int, required)
- Behavior: Returns `{ id, url }` if accessible. When `au_requires_auth` is true, user must be authenticated.

### GET /download-proxy (optional)

- Query: `id` (int, required), `disposition` (string: `attachment`|`inline`, default `attachment`)
- Behavior: Issues a 302 redirect to the file URL with Content-Disposition header. Enforces `au_requires_auth` like GET /download. Useful to hide direct URLs.

