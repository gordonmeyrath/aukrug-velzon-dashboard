# Aukrug App - API Contract

## Overview

The Aukrug App communicates with a WordPress backend via REST API endpoints. This document defines the API contract, data structures, error handling, and caching strategies.

## Base Configuration

**Base URL**: `https://aukrug.de/wp-json/aukrug/v1`

**Authentication**: Currently public endpoints; future JWT implementation planned

**Content-Type**: `application/json`

**Caching**: ETag-based caching with `If-None-Match` headers

## Core Endpoints

### Places API

#### GET /places

Retrieve all places of interest.

**Response**:

```json
{
  "data": [
    {
      "id": "place_001",
      "name": "Aukrug-See",
      "description": "Beautiful lake for swimming and recreation",
      "category": "nature",
      "coordinates": {
        "lat": 54.1234,
        "lng": 9.5678
      },
      "website": "https://example.com",
      "phone": "+49 4321 12345",
      "images": [
        "https://aukrug.de/wp-content/uploads/place_001_1.jpg"
      ]
    }
  ],
  "meta": {
    "count": 25,
    "last_modified": "2024-01-15T10:30:00Z"
  }
}
```

**ETag Header**: `W/"places-v1-20240115103000"`

#### GET /places/{id}

Retrieve specific place details.

**Parameters**:

- `id` (string): Unique place identifier

**Response**: Single place object (same structure as above)

### Events API

#### GET /events

Retrieve upcoming events.

**Query Parameters**:

- `from` (ISO date): Start date filter (default: today)
- `to` (ISO date): End date filter (default: +30 days)
- `audience` (enum): `tourist` | `resident` | `both` (default: both)

**Response**:

```json
{
  "data": [
    {
      "id": "event_001",
      "title": "Aukrug Dorffest",
      "description": "Annual village festival with local food and music",
      "start_date": "2024-06-15T14:00:00Z",
      "end_date": "2024-06-15T22:00:00Z",
      "location": {
        "name": "Dorfplatz Aukrug",
        "address": "Hauptstraße 1, 24613 Aukrug",
        "coordinates": {
          "lat": 54.1234,
          "lng": 9.5678
        }
      },
      "audience": "both",
      "category": "festival",
      "website": "https://example.com/event",
      "image": "https://aukrug.de/wp-content/uploads/event_001.jpg"
    }
  ],
  "meta": {
    "count": 12,
    "last_modified": "2024-01-15T10:30:00Z"
  }
}
```

### Notices API (Residents Only)

#### GET /notices

Retrieve municipal notices and announcements.

**Query Parameters**:

- `priority` (enum): `low` | `normal` | `high` | `urgent`
- `category` (string): Notice category filter
- `limit` (int): Maximum results (default: 50)

**Response**:

```json
{
  "data": [
    {
      "id": "notice_001",
      "title": "Straßensperrung Hauptstraße",
      "content": "Die Hauptstraße wird vom 15.-17. Juni für Bauarbeiten gesperrt.",
      "priority": "high",
      "category": "traffic",
      "published_date": "2024-06-10T08:00:00Z",
      "valid_until": "2024-06-17T23:59:59Z",
      "attachments": [
        {
          "name": "Umleitungsplan.pdf",
          "url": "https://aukrug.de/wp-content/uploads/umleitung.pdf",
          "type": "application/pdf",
          "size": 245760
        }
      ]
    }
  ],
  "meta": {
    "count": 8,
    "last_modified": "2024-01-15T10:30:00Z"
  }
}
```

### Downloads API (Residents Only)

#### GET /downloads

Retrieve downloadable documents and forms.

**Query Parameters**:

- `category` (string): Document category
- `search` (string): Search in title and description

**Response**:

```json
{
  "data": [
    {
      "id": "download_001",
      "title": "Anmeldung Gewerbe",
      "description": "Formular zur Gewerbeanmeldung",
      "category": "forms",
      "file_url": "https://aukrug.de/wp-content/uploads/gewerbe_anmeldung.pdf",
      "file_type": "application/pdf",
      "file_size": 1024000,
      "updated_date": "2024-01-10T09:00:00Z"
    }
  ],
  "meta": {
    "count": 15,
    "last_modified": "2024-01-15T10:30:00Z"
  }
}
```

### Reports API (Residents Only)

#### POST /reports

Submit a municipal issue report (Mängelmelder).

**Request Body**:

```json
{
  "category": "infrastructure",
  "title": "Schlagloch auf Dorfstraße",
  "description": "Großes Schlagloch vor Hausnummer 15",
  "location": {
    "coordinates": {
      "lat": 54.1234,
      "lng": 9.5678
    },
    "address": "Dorfstraße 15, 24613 Aukrug"
  },
  "images": ["base64_encoded_image_data"],
  "contact": {
    "name": "Max Mustermann",
    "email": "max@example.com",
    "phone": "+49 1234 567890"
  }
}
```

**Response**:

```json
{
  "data": {
    "id": "report_001",
    "reference_number": "AUK-2024-001",
    "status": "submitted",
    "submitted_date": "2024-01-15T10:30:00Z",
    "estimated_completion": "2024-01-22T00:00:00Z"
  }
}
```

#### GET /reports/{id}

Check status of submitted report.

**Response**:

```json
{
  "data": {
    "id": "report_001",
    "reference_number": "AUK-2024-001",
    "status": "in_progress",
    "submitted_date": "2024-01-15T10:30:00Z",
    "last_updated": "2024-01-16T14:20:00Z",
    "status_history": [
      {
        "status": "submitted",
        "date": "2024-01-15T10:30:00Z",
        "note": "Report received"
      },
      {
        "status": "in_progress",
        "date": "2024-01-16T14:20:00Z",
        "note": "Assigned to maintenance team"
      }
    ]
  }
}
```

## Data Types

### Common Enums

```dart
enum PlaceCategory {
  nature,
  restaurant,
  accommodation,
  shopping,
  culture,
  sport,
  service
}

enum EventCategory {
  festival,
  meeting,
  sport,
  culture,
  education
}

enum ReportCategory {
  infrastructure,
  environment,
  safety,
  other
}

enum ReportStatus {
  submitted,
  reviewed,
  in_progress,
  completed,
  rejected
}
```

### Coordinate System

All coordinates use **WGS84 (EPSG:4326)** decimal degrees format.

## Error Handling

### HTTP Status Codes

- `200`: Success
- `304`: Not Modified (ETag cache hit)
- `400`: Bad Request (validation error)
- `401`: Unauthorized
- `403`: Forbidden (audience restriction)
- `404`: Not Found
- `429`: Rate Limited
- `500`: Internal Server Error

### Error Response Format

```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Required field missing: title",
    "details": {
      "field": "title",
      "rule": "required"
    }
  }
}
```

### Common Error Codes

- `VALIDATION_ERROR`: Request validation failed
- `NOT_FOUND`: Resource not found
- `RATE_LIMITED`: Too many requests
- `AUDIENCE_RESTRICTED`: Content not available for selected audience
- `MAINTENANCE_MODE`: API temporarily unavailable

## Caching Strategy

### ETag Implementation

**Client Behavior**:

1. First request: Store ETag from response header
2. Subsequent requests: Send `If-None-Match: {etag}`
3. 304 response: Use cached data
4. 200 response: Update cache with new data

**ETag Format**: `W/"endpoint-version-timestamp"`

Example: `W/"places-v1-20240115103000"`

### Cache Invalidation

Cache is invalidated when:

- Manual refresh triggered by user
- App returns from background after 1 hour
- Network connectivity restored after offline period

## Rate Limiting

- **Limit**: 100 requests per hour per IP
- **Header**: `X-RateLimit-Remaining: 95`
- **Reset**: `X-RateLimit-Reset: 1642248000`

## Future API Extensions

### Planned Endpoints

- `GET /routes`: Hiking and cycling routes with GPX data
- `GET /weather`: Local weather information
- `POST /feedback`: General app feedback
- `GET /notifications`: Push notification management

### Authentication (Planned)

JWT-based authentication for enhanced features:

- Personal report history
- Favorite places and events
- Push notification preferences

**Login Flow**:

```
POST /auth/login
{
  "email": "user@example.com",
  "password": "secure_password"
}

Response:
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "expires_in": 3600
}
```

## Testing Endpoints

### Development Environment

**Base URL**: `https://staging.aukrug.de/wp-json/aukrug/v1`

**Mock Data**: All endpoints return fixture data for testing

### Postman Collection

A Postman collection is available for API testing:

- Environment variables for staging/production
- Pre-request scripts for authentication
- Test assertions for response validation
