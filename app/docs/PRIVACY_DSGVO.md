# Aukrug App - Privacy & DSGVO Compliance

## Overview

The Aukrug App is designed with **Privacy by Design** principles and full compliance with the European General Data Protection Regulation (DSGVO/GDPR). This document outlines our data protection measures, user rights, and implementation details.

## Legal Basis

### Art. 6 DSGVO - Lawfulness of Processing

**Legitimate Interest (Art. 6(1)(f) DSGVO)**:

- Providing municipal services to residents
- Tourist information and local business promotion
- Infrastructure maintenance through citizen reports

**Consent (Art. 6(1)(a) DSGVO)**:

- Analytics data collection (opt-in)
- Push notifications (opt-in)
- Location services for enhanced features (opt-in)

### Data Controller

**Municipality of Aukrug**

Address: Bargfelder Straße 1, 24613 Aukrug, Germany

Phone: +49 4391 599-0

Email: <datenschutz@aukrug.de>

**Data Protection Officer**: Available on request

## Data Categories & Processing

### Essential Data (No Consent Required)

**App Functionality Data**:

- Audience selection (Tourist/Resident)
- Language preference (German/English)
- Accessibility settings (high contrast, large text)
- Cached content for offline use

**Technical Data**:

- App version and device information
- Crash logs and error reports (anonymized)
- Network connectivity status

**Local Storage Only**: This data never leaves the device

### Optional Data (Consent Required)

#### Analytics Data (Opt-Out by Default)

**Purpose**: App improvement and usage statistics

**Data Collected**:

- Screen views and user interactions (anonymized)
- Feature usage frequency
- App performance metrics
- General location (city level only)

**Retention**: 24 months, then automatically deleted

**Third-Party**: Google Analytics 4 (Privacy Mode enabled)

#### Location Data (Opt-In)

**Purpose**: Enhanced map features and location-based services

**Data Collected**:

- Precise GPS coordinates when using map features
- Approximate location for weather information
- Location of submitted reports (with explicit consent)

**Storage**: Device only, never transmitted to servers

#### Push Notifications (Opt-In)

**Purpose**: Important municipal notices and emergency alerts

**Data Collected**:

- Device push token
- Notification preferences
- Delivery status

**Storage**: Firebase Cloud Messaging

## User Rights (Art. 12-22 DSGVO)

### Right of Access (Art. 15)

Users can view all their data through the app's **Privacy Dashboard**:

- Data categories and purposes
- Storage locations and retention periods
- Third-party data sharing (if any)

### Right to Rectification (Art. 16)

Users can correct their data:

- Update contact information for reports
- Modify accessibility preferences
- Change language settings

### Right to Erasure (Art. 17)

**Complete Data Deletion**:

- "Delete all my data" button in settings
- Removes all local storage, preferences, and cached content
- Requests deletion from analytics services

**Implementation**: Local database cleared, SharedPreferences reset

### Right to Data Portability (Art. 20)

Users can export their data in JSON format:

- Personal settings and preferences
- Submitted reports and their status
- Favorite places and events (if implemented)

### Right to Object (Art. 21)

Users can object to any data processing:

- Disable analytics completely
- Opt out of all optional features
- Use app with minimal data collection

### Rights Related to Automated Decision-Making (Art. 22)

**No Automated Decisions**: The app does not use automated decision-making or profiling

## Technical Implementation

### Data Minimization

**Principle**: Collect only data necessary for specific purposes

**Implementation**:

- Granular consent per data category
- Local-first architecture reduces data transmission
- Automatic data expiration and cleanup
- No background data collection

### Data Protection by Design

**Technical Measures**:

```dart
// Example: Privacy-aware analytics
class AnalyticsService {
  static Future<void> trackEvent(String event, {Map<String, String>? params}) async {
    // Check consent before any tracking
    final hasConsent = await ConsentManager.hasAnalyticsConsent();
    if (!hasConsent) return;
    
    // Anonymize data
    final anonymizedParams = _anonymizeParameters(params);
    
    // Track with privacy settings
    await FirebaseAnalytics.instance.logEvent(
      name: event,
      parameters: anonymizedParams,
    );
  }
}
```

**Storage Encryption**:

- All local data encrypted at rest
- HTTPS-only communication
- Certificate pinning for API security

### Consent Management

**Consent Dialog Implementation**:

```dart
class ConsentPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Column(
        children: [
          // Clear explanations for each data category
          ConsentToggle(
            title: 'Analytics (Optional)',
            description: 'Hilft uns, die App zu verbessern. Alle Daten werden anonymisiert.',
            onChanged: (value) => ref.read(consentProvider.notifier).setAnalytics(value),
          ),
          ConsentToggle(
            title: 'Push-Benachrichtigungen (Optional)',
            description: 'Wichtige Mitteilungen der Gemeinde erhalten.',
            onChanged: (value) => ref.read(consentProvider.notifier).setNotifications(value),
          ),
          ConsentToggle(
            title: 'Standort (Optional)',
            description: 'Für ortsbezogene Funktionen und Kartenansicht.',
            onChanged: (value) => ref.read(consentProvider.notifier).setLocation(value),
          ),
        ],
      ),
    );
  }
}
```

**Consent Storage**:

- Stored locally in SharedPreferences
- Versioned consent (track changes over time)
- Easy withdrawal mechanism

## Data Retention

### Automatic Deletion

**Cache Data**: 24 hours for temporary content, 7 days for images

**Analytics**: 24 months, then automatically deleted

**Crash Reports**: 90 days for debugging, then deleted

**User Preferences**: Retained until app deletion or explicit user action

### Manual Deletion

Users can delete specific data categories:

- Clear image cache
- Reset all preferences
- Delete analytics history
- Remove all stored consent

## Third-Party Services

### Google Analytics 4

**Purpose**: App improvement and usage statistics

**Data Shared**: Anonymized usage patterns, no personal information

**Privacy Controls**:

- IP anonymization enabled
- Advertising features disabled
- Data retention set to 24 months
- User can opt-out completely

**Legal Basis**: Consent (opt-out by default)

### Firebase Cloud Messaging

**Purpose**: Push notifications for municipal notices

**Data Shared**: Device push token only

**Privacy Controls**:

- Opt-in required
- Easy unsubscribe
- No message content stored

**Legal Basis**: Consent (opt-in required)

### OpenStreetMap

**Purpose**: Map display and routing

**Data Shared**: No personal data, only map tile requests

**Privacy**: No tracking, no cookies, no user accounts

**Legal Basis**: Legitimate interest (essential functionality)

## Children's Privacy

**Age Restriction**: The app is intended for users 13 years and older

**Implementation**: 

- No special data collection for children
- Parental consent mechanism (future enhancement)
- Clear language in privacy notices

## Data Breach Protocol

**Detection**: Automated monitoring for unauthorized access

**Response Plan**:

1. **72 hours**: Notify supervisory authority (if risk to users)
2. **Without delay**: Notify affected users (if high risk)
3. **Immediate**: Contain breach and assess impact
4. **Ongoing**: Monitor and prevent future incidents

**Contact**: <datenschutz@aukrug.de> for security reports

## Privacy Dashboard

**Accessible via**: Settings → Privacy & Data

**Features**:

- View current consent status
- Modify data collection preferences
- Export personal data (JSON format)
- Delete all data with confirmation
- Contact data protection officer

**Implementation**:

```dart
class PrivacyDashboard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final consent = ref.watch(consentProvider);
    
    return Scaffold(
      appBar: AppBar(title: Text('Privacy & Data')),
      body: ListView(
        children: [
          // Current consent status
          ConsentStatusCard(consent: consent),
          
          // Data categories
          DataCategoryCard(
            title: 'Analytics',
            enabled: consent.analytics,
            onToggle: (value) => ref.read(consentProvider.notifier).setAnalytics(value),
          ),
          
          // Data export
          ListTile(
            title: Text('Export My Data'),
            onTap: () => _exportUserData(ref),
          ),
          
          // Data deletion
          ListTile(
            title: Text('Delete All Data'),
            onTap: () => _showDeleteConfirmation(context, ref),
          ),
        ],
      ),
    );
  }
}
```

## Compliance Checklist

### DSGVO Requirements ✅

- [x] **Legal basis identified** for all data processing
- [x] **Consent mechanisms** implemented where required
- [x] **Privacy notices** clear and accessible
- [x] **User rights** fully implemented
- [x] **Data minimization** principle applied
- [x] **Data protection by design** implemented
- [x] **Breach notification** procedures established
- [x] **Data retention** policies defined
- [x] **Third-party agreements** privacy-compliant

### Technical Implementation ✅

- [x] **Local-first architecture** minimizes data transmission
- [x] **Encryption** for all sensitive data
- [x] **Secure communication** (HTTPS, certificate pinning)
- [x] **Granular consent** per data category
- [x] **Easy data deletion** for users
- [x] **Privacy dashboard** for user control
- [x] **No tracking by default** approach

## Contact & Support

**Privacy Questions**: <datenschutz@aukrug.de>

**Technical Issues**: <support@aukrug.de>

**Supervisory Authority**: 
Der Landesbeauftragte für Datenschutz Schleswig-Holstein
Holstenstraße 98, 24103 Kiel
Phone: +49 431 988-1200
Email: <mail@datenschutzzentrum.de>

## Updates

This privacy implementation will be reviewed and updated as needed to maintain compliance with evolving privacy regulations and best practices.

**Last Updated**: January 2024
**Next Review**: July 2024
