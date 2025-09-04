import '../domain/notice.dart';

class NoticesRepository {
  /// Get notices from fixtures (offline-first approach)
  Future<List<Notice>> getNotices() async {
    try {
      // For now, return mock data since we don't have fixture file yet
      return _getMockNotices();
    } catch (e) {
      // Return empty list if loading fails
      return [];
    }
  }

  /// Get notices by priority
  Future<List<Notice>> getNoticesByPriority(NoticePriority priority) async {
    final notices = await getNotices();
    return notices.where((notice) => notice.priority == priority).toList();
  }

  /// Get urgent notices
  Future<List<Notice>> getUrgentNotices() async {
    return getNoticesByPriority(NoticePriority.urgent);
  }

  /// Get notices by category
  Future<List<Notice>> getNoticesByCategory(String category) async {
    final notices = await getNotices();
    return notices.where((notice) => notice.category == category).toList();
  }

  /// Search notices by query
  Future<List<Notice>> searchNotices(String query) async {
    final notices = await getNotices();
    final lowerQuery = query.toLowerCase();

    return notices.where((notice) {
      return notice.title.toLowerCase().contains(lowerQuery) ||
          notice.content.toLowerCase().contains(lowerQuery) ||
          notice.tags.any((tag) => tag.toLowerCase().contains(lowerQuery));
    }).toList();
  }

  /// Get a specific notice by ID
  Future<Notice?> getNotice(int id) async {
    final notices = await getNotices();
    try {
      return notices.firstWhere((notice) => notice.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Mock data for development
  List<Notice> _getMockNotices() {
    final now = DateTime.now();
    return [
      Notice(
        id: 1,
        title: 'Straßensperrung Hauptstraße',
        content:
            'Die Hauptstraße wird vom 15.-17. September für Bauarbeiten gesperrt. Bitte nutzen Sie die Umleitung über die Dorfstraße.',
        publishedDate: now.subtract(const Duration(days: 2)),
        validUntil: now.add(const Duration(days: 5)),
        priority: NoticePriority.high,
        category: 'Verkehr',
        attachments: [
          const NoticeAttachment(
            name: 'Umleitungsplan.pdf',
            url: 'https://aukrug.de/attachments/umleitung.pdf',
            type: 'application/pdf',
            size: 245760,
          ),
        ],
        tags: ['verkehr', 'sperrung', 'umleitung'],
      ),
      Notice(
        id: 2,
        title: 'Gemeinderatssitzung September',
        content:
            'Die nächste öffentliche Gemeinderatssitzung findet am 20. September um 19:00 Uhr im Rathaus statt.',
        publishedDate: now.subtract(const Duration(days: 5)),
        priority: NoticePriority.normal,
        category: 'Verwaltung',
        tags: ['gemeinderat', 'sitzung', 'öffentlich'],
      ),
      Notice(
        id: 3,
        title: 'Unwetter-Warnung',
        content:
            'Der Deutsche Wetterdienst warnt vor schweren Gewittern für heute Abend. Bringen Sie lose Gegenstände in Sicherheit.',
        publishedDate: now.subtract(const Duration(hours: 2)),
        validUntil: now.add(const Duration(hours: 12)),
        priority: NoticePriority.urgent,
        category: 'Wetter',
        tags: ['unwetter', 'warnung', 'gewitter'],
      ),
      Notice(
        id: 4,
        title: 'Öffnungszeiten Bürgerbüro',
        content:
            'Das Bürgerbüro hat ab dem 1. Oktober neue Öffnungszeiten: Mo-Fr 8:00-16:00, Do bis 18:00 Uhr.',
        publishedDate: now.subtract(const Duration(days: 10)),
        priority: NoticePriority.normal,
        category: 'Verwaltung',
        tags: ['bürgerbüro', 'öffnungszeiten'],
      ),
    ];
  }
}
