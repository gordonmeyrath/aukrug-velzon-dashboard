import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../theme/color_extensions.dart';

/// Demo Content Provider für Testing der App im Simulator
class DemoContentService {
  static const List<Map<String, dynamic>> demoReports = [
    {
      'id': 'demo_001',
      'title': 'Schlagloch in der Dorfstraße',
      'description':
          'Großes Schlagloch vor dem Bäcker. Gefahr für Fahrradfahrer!',
      'category': 'Straßenschäden',
      'status': 'offen',
      'priority': 'hoch',
      'createdAt': '2025-09-01T10:30:00Z',
      'location': {
        'latitude': 54.1215,
        'longitude': 9.6892,
        'address': 'Dorfstraße 12, 24613 Aukrug',
      },
      'photos': ['assets/images/demo_pothole.jpg'],
      'isDemo': true,
    },
    {
      'id': 'demo_002',
      'title': 'Defekte Straßenlaterne',
      'description':
          'Straßenlaterne am Spielplatz funktioniert nicht mehr. Bereich ist abends sehr dunkel.',
      'category': 'Beleuchtung',
      'status': 'in_bearbeitung',
      'priority': 'mittel',
      'createdAt': '2025-08-28T14:15:00Z',
      'location': {
        'latitude': 54.1198,
        'longitude': 9.6875,
        'address': 'Am Spielplatz 3, 24613 Aukrug',
      },
      'photos': [],
      'isDemo': true,
    },
    {
      'id': 'demo_003',
      'title': 'Wilder Müll im Wald',
      'description':
          'Größere Menge Müll wurde illegal im Waldstück hinter der Schule entsorgt.',
      'category': 'Umwelt',
      'status': 'erledigt',
      'priority': 'hoch',
      'createdAt': '2025-08-25T09:45:00Z',
      'location': {
        'latitude': 54.1232,
        'longitude': 9.6845,
        'address': 'Waldweg, 24613 Aukrug',
      },
      'photos': ['assets/images/demo_waste.jpg'],
      'isDemo': true,
    },
  ];

  static const List<Map<String, dynamic>> demoEvents = [
    {
      'id': 'event_001',
      'title': 'Dorfgemeinschaftsfest',
      'description':
          'Jährliches Fest der Dorfgemeinschaft mit Livemusik, Grillstand und Kinderprogramm.',
      'category': 'Fest',
      'startDate': '2025-09-14T15:00:00Z',
      'endDate': '2025-09-14T22:00:00Z',
      'location': {
        'latitude': 54.1205,
        'longitude': 9.6885,
        'address': 'Dorfplatz, 24613 Aukrug',
      },
      'organizer': 'Dorfgemeinschaft Aukrug e.V.',
      'isDemo': true,
    },
    {
      'id': 'event_002',
      'title': 'Gemeinderatssitzung',
      'description':
          'Öffentliche Sitzung des Gemeinderats. Bürgerfragen zur Verkehrssituation.',
      'category': 'Politik',
      'startDate': '2025-09-18T19:00:00Z',
      'endDate': '2025-09-18T21:00:00Z',
      'location': {
        'latitude': 54.1189,
        'longitude': 9.6901,
        'address': 'Rathaus, Hauptstraße 45, 24613 Aukrug',
      },
      'organizer': 'Gemeinde Aukrug',
      'isDemo': true,
    },
    {
      'id': 'event_003',
      'title': 'Herbstmarkt',
      'description':
          'Regionaler Markt mit lokalen Produkten, Handwerk und Herbstdekoration.',
      'category': 'Markt',
      'startDate': '2025-09-21T09:00:00Z',
      'endDate': '2025-09-21T16:00:00Z',
      'location': {
        'latitude': 54.1210,
        'longitude': 9.6890,
        'address': 'Marktplatz, 24613 Aukrug',
      },
      'organizer': 'Gewerbeverein Aukrug',
      'isDemo': true,
    },
  ];

  static const List<Map<String, dynamic>> demoNotices = [
    {
      'id': 'notice_001',
      'title': 'Sperrung der Hauptstraße',
      'content':
          'Die Hauptstraße wird vom 10.09. bis 15.09.2025 zwischen Hausnummer 20 und 50 aufgrund von Kanalbauarbeiten voll gesperrt. Umleitung über die Nebenstraße.',
      'category': 'Verkehr',
      'priority': 'hoch',
      'publishedAt': '2025-09-05T08:00:00Z',
      'validUntil': '2025-09-15T23:59:00Z',
      'isDemo': true,
    },
    {
      'id': 'notice_002',
      'title': 'Neue Öffnungszeiten Bürgerbüro',
      'content':
          'Ab dem 1. Oktober 2025 hat das Bürgerbüro erweiterte Öffnungszeiten: Mo-Fr 8:00-18:00 Uhr, Sa 9:00-13:00 Uhr.',
      'category': 'Service',
      'priority': 'mittel',
      'publishedAt': '2025-09-01T10:00:00Z',
      'validUntil': '2025-12-31T23:59:00Z',
      'isDemo': true,
    },
    {
      'id': 'notice_003',
      'title': 'Grünschnitt-Abholung',
      'content':
          'Die nächste Grünschnitt-Abholung findet am 16. September 2025 statt. Bitte bis 7:00 Uhr bereitstellen.',
      'category': 'Entsorgung',
      'priority': 'niedrig',
      'publishedAt': '2025-09-03T12:00:00Z',
      'validUntil': '2025-09-16T23:59:00Z',
      'isDemo': true,
    },
  ];

  static const List<Map<String, dynamic>> demoPlaces = [
    {
      'id': 'place_001',
      'name': 'Aukrug Rathaus',
      'description':
          'Historisches Rathaus von 1892 mit charakteristischer norddeutscher Backsteinarchitektur.',
      'category': 'Sehenswürdigkeit',
      'type': 'Öffentliches Gebäude',
      'location': {
        'latitude': 54.1189,
        'longitude': 9.6901,
        'address': 'Hauptstraße 45, 24613 Aukrug',
      },
      'openingHours': 'Mo-Fr 8:00-16:00',
      'contact': {
        'phone': '04873 / 891-0',
        'email': 'info@aukrug.de',
        'website': 'https://www.aukrug.de',
      },
      'images': ['assets/images/demo_rathaus.jpg'],
      'isDemo': true,
    },
    {
      'id': 'place_002',
      'name': 'Naturschutzgebiet Aukrug',
      'description':
          'Wunderschönes Naturschutzgebiet mit seltenen Pflanzen und Vogelarten. Ideal für Wanderungen.',
      'category': 'Natur',
      'type': 'Naturschutzgebiet',
      'location': {
        'latitude': 54.1250,
        'longitude': 9.6820,
        'address': 'Naturschutzgebiet Aukrug',
      },
      'openingHours': 'Ganzjährig zugänglich',
      'contact': {'phone': '04873 / 891-25', 'email': 'umwelt@aukrug.de'},
      'images': ['assets/images/demo_nature.jpg'],
      'isDemo': true,
    },
    {
      'id': 'place_003',
      'name': 'Dorfmuseum Aukrug',
      'description':
          'Kleines aber feines Museum zur Geschichte der Gemeinde mit interessanten Exponaten.',
      'category': 'Kultur',
      'type': 'Museum',
      'location': {
        'latitude': 54.1200,
        'longitude': 9.6880,
        'address': 'Museumstraße 8, 24613 Aukrug',
      },
      'openingHours': 'Sa-So 14:00-17:00',
      'contact': {'phone': '04873 / 1234', 'email': 'museum@aukrug.de'},
      'images': ['assets/images/demo_museum.jpg'],
      'isDemo': true,
    },
  ];

  /// Demo User für Testing
  static Map<String, dynamic> getDemoUser() {
    return {
      'id': 'demo_user_001',
      'email': 'demo@aukrug.de',
      'displayName': 'Demo Nutzer',
      'isAnonymous': false,
      'createdAt': DateTime.now()
          .subtract(const Duration(days: 30))
          .toIso8601String(),
      'lastLoginAt': DateTime.now().toIso8601String(),
      'preferences': {
        'theme': 'system',
        'language': 'de',
        'locationAccuracy': 'balanced',
        'imageQuality': 'standard',
        'enableNotifications': true,
        'allowOfflineMode': true,
      },
      'privacySettings': {
        'consentToLocationProcessing': true,
        'consentToPhotoProcessing': true,
        'consentToAnalytics': false,
        'consentToMarketing': false,
        'allowReportSubmission': true,
        'allowLocationTracking': true,
        'allowUsageAnalytics': false,
        'allowPersonalization': true,
        'dataRetentionPeriod': 'oneYear',
        'autoDeleteOldReports': false,
        'anonymizeOldData': false,
        'allowEmailContact': true,
        'allowPhoneContact': false,
        'consentGivenAt': DateTime.now()
            .subtract(const Duration(days: 30))
            .toIso8601String(),
      },
      'isDemo': true,
    };
  }

  /// DSGVO-konforme Demo-Daten für Privacy-Testing
  static Map<String, dynamic> getDemoPrivacyData() {
    return {
      'dataProcessingPurposes': [
        {
          'purpose': 'Meldungen verwalten',
          'legalBasis': 'Berechtigtes Interesse (Art. 6 Abs. 1 lit. f DSGVO)',
          'dataTypes': ['Standortdaten', 'Beschreibungstext', 'Fotos'],
          'retention': '1 Jahr',
          'consent': 'Erforderlich',
        },
        {
          'purpose': 'Benutzer-Account verwalten',
          'legalBasis': 'Vertrag (Art. 6 Abs. 1 lit. b DSGVO)',
          'dataTypes': ['E-Mail', 'Name', 'Einstellungen'],
          'retention': 'Bis zur Löschung',
          'consent': 'Freiwillig',
        },
        {
          'purpose': 'App-Verbesserung',
          'legalBasis': 'Einwilligung (Art. 6 Abs. 1 lit. a DSGVO)',
          'dataTypes': ['Nutzungsstatistiken'],
          'retention': '6 Monate',
          'consent': 'Optional',
        },
      ],
      'userRights': [
        'Auskunft (Art. 15 DSGVO)',
        'Berichtigung (Art. 16 DSGVO)',
        'Löschung (Art. 17 DSGVO)',
        'Einschränkung (Art. 18 DSGVO)',
        'Datenübertragbarkeit (Art. 20 DSGVO)',
        'Widerspruch (Art. 21 DSGVO)',
      ],
      'dataProtectionContact': {
        'name': 'Gemeinde Aukrug - Datenschutzbeauftragte',
        'email': 'datenschutz@aukrug.de',
        'phone': '04873 / 891-15',
        'address': 'Hauptstraße 45, 24613 Aukrug',
      },
    };
  }
}

/// Provider für Demo Content
final demoContentProvider = Provider<DemoContentService>((ref) {
  return DemoContentService();
});

/// Demo Banner Widget für Simulator Testing
class DemoBanner extends StatelessWidget {
  final Widget child;

  const DemoBanner({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Banner(
      message: 'DEMO',
      location: BannerLocation.topEnd,
      color: Colors.orange,
      child: child,
    );
  }
}

/// Demo Status Widget
class DemoStatusWidget extends ConsumerWidget {
  const DemoStatusWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.orange.alphaFrac(0.1),
        border: Border.all(color: Colors.orange),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.science, size: 16, color: Colors.orange),
          const SizedBox(width: 4),
          Text(
            'Demo Modus',
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.orange,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

/// Demo Privacy Notice
class DemoPrivacyNotice extends StatelessWidget {
  const DemoPrivacyNotice({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.primary.alphaFrac(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: theme.colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Demo-Hinweis',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Diese App läuft im Demo-Modus mit Beispieldaten. '
            'Alle gezeigten Inhalte sind fiktiv und dienen nur der Demonstration '
            'der DSGVO-konformen Funktionalität.',
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.security, color: Colors.green, size: 16),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  'Vollständig DSGVO-konform mit Privacy by Design',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
