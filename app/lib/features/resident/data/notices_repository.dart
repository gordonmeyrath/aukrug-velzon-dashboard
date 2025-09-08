import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/notice.dart';

part 'notices_repository.g.dart';

@riverpod
class NoticesRepository extends _$NoticesRepository {
  @override
  Future<List<Notice>> build() async {
    return _getMockData();
  }

  Future<List<Notice>> getNotices({
    NoticeCategory? category,
    String? searchQuery,
    bool? onlyImportant,
  }) async {
    var notices = await build();

    if (category != null) {
      notices = notices.where((notice) => notice.category == category).toList();
    }

    if (onlyImportant == true) {
      notices = notices.where((notice) => notice.isImportant).toList();
    }

    if (searchQuery != null && searchQuery.isNotEmpty) {
      notices = notices
          .where(
            (notice) =>
                notice.title.toLowerCase().contains(
                  searchQuery.toLowerCase(),
                ) ||
                notice.content.toLowerCase().contains(
                  searchQuery.toLowerCase(),
                ),
          )
          .toList();
    }

    // Sort by pinned first, then by date
    notices.sort((a, b) {
      if (a.isPinned && !b.isPinned) return -1;
      if (!a.isPinned && b.isPinned) return 1;
      return b.publishedAt.compareTo(a.publishedAt);
    });

    return notices;
  }

  List<Notice> _getMockData() {
    final now = DateTime.now();

    return [
      Notice(
        id: '1',
        title: 'Sperrung der Hauptstraße',
        content:
            'Aufgrund von Bauarbeiten wird die Hauptstraße vom 15. bis 20. September vollgesperrt. Eine Umleitung wird eingerichtet. Wir bitten um Verständnis für die Unannehmlichkeiten.',
        category: NoticeCategory.verkehr,
        publishedAt: now.subtract(const Duration(hours: 2)),
        isImportant: true,
        isPinned: true,
        authorName: 'Straßenbauamt',
        departmentName: 'Tiefbau',
        validUntil: DateTime(2025, 9, 20),
      ),
      Notice(
        id: '2',
        title: 'Neues Baugebiet "Am Waldrand"',
        content:
            'Die Gemeinde Aukrug plant ein neues Wohnbaugebiet "Am Waldrand". Interessierte Bürger können sich ab sofort im Rathaus informieren. Eine Informationsveranstaltung findet am 25. September um 19:00 Uhr im Gemeindezentrum statt.',
        category: NoticeCategory.bauen,
        publishedAt: now.subtract(const Duration(days: 1)),
        isImportant: false,
        authorName: 'Bürgermeister Schmidt',
        departmentName: 'Bauamt',
        attachmentUrls: ['https://example.com/baugebiet-plan.pdf'],
      ),
      Notice(
        id: '3',
        title: 'Herbstfest 2025',
        content:
            'Das traditionelle Aukruger Herbstfest findet am 30. September auf dem Marktplatz statt. Neben regionalen Spezialitäten erwartet Sie ein buntes Programm mit Musik und Kinderattraktionen. Beginn: 14:00 Uhr.',
        category: NoticeCategory.kultur,
        publishedAt: now.subtract(const Duration(days: 2)),
        isImportant: false,
        authorName: 'Kulturverein Aukrug',
        departmentName: 'Kultur',
      ),
      Notice(
        id: '4',
        title: 'Müllabfuhr verschoben',
        content:
            'Aufgrund des Feiertags wird die Müllabfuhr in der kommenden Woche um einen Tag verschoben. Bitte stellen Sie Ihre Tonnen entsprechend später raus.',
        category: NoticeCategory.umwelt,
        publishedAt: now.subtract(const Duration(days: 3)),
        isImportant: true,
        authorName: 'Gemeindeverwaltung',
        departmentName: 'Umwelt',
      ),
      Notice(
        id: '5',
        title: 'Öffnungszeiten Rathaus',
        content:
            'Das Rathaus ist aufgrund einer internen Schulung am 18. September nur bis 12:00 Uhr geöffnet. Dringende Angelegenheiten können telefonisch geklärt werden.',
        category: NoticeCategory.verwaltung,
        publishedAt: now.subtract(const Duration(days: 4)),
        isImportant: false,
        authorName: 'Bürgerservice',
        departmentName: 'Verwaltung',
      ),
      Notice(
        id: '6',
        title: 'Sportplatz-Sanierung',
        content:
            'Der Hauptsportplatz wird in den nächsten drei Wochen saniert. In dieser Zeit stehen die Nebenplätze für Vereinsaktivitäten zur Verfügung.',
        category: NoticeCategory.sport,
        publishedAt: now.subtract(const Duration(days: 5)),
        isImportant: false,
        authorName: 'Sportverein Aukrug',
        departmentName: 'Sport',
        validUntil: DateTime(2025, 10, 15),
      ),
      Notice(
        id: '7',
        title: 'Bürgersprechstunde',
        content:
            'Die nächste Bürgersprechstunde findet am 22. September von 16:00 bis 18:00 Uhr im Rathaus statt. Eine Anmeldung ist nicht erforderlich.',
        category: NoticeCategory.termine,
        publishedAt: now.subtract(const Duration(days: 6)),
        isImportant: false,
        isPinned: true,
        authorName: 'Bürgermeister Schmidt',
        departmentName: 'Verwaltung',
      ),
      Notice(
        id: '8',
        title: 'Wassersperrung angekündigt',
        content:
            'Am 19. September zwischen 9:00 und 15:00 Uhr wird die Wasserversorgung in der Birkenstraße und Umgebung unterbrochen. Betroffene Haushalte wurden bereits informiert.',
        category: NoticeCategory.verwaltung,
        publishedAt: now.subtract(const Duration(days: 7)),
        isImportant: true,
        authorName: 'Stadtwerke',
        departmentName: 'Versorgung',
      ),
    ];
  }
}
