import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/route_item.dart';

part 'routes_repository.g.dart';

@riverpod
class RoutesRepository extends _$RoutesRepository {
  @override
  Future<List<RouteItem>> build() async {
    return _getMockData();
  }

  Future<List<RouteItem>> getRoutes({
    RouteType? type,
    RouteDifficulty? difficulty,
    String? searchQuery,
  }) async {
    var routes = await build();

    if (type != null) {
      routes = routes.where((route) => route.type == type).toList();
    }

    if (difficulty != null) {
      routes = routes.where((route) => route.difficulty == difficulty).toList();
    }

    if (searchQuery != null && searchQuery.isNotEmpty) {
      routes = routes
          .where(
            (route) =>
                route.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
                route.description.toLowerCase().contains(
                  searchQuery.toLowerCase(),
                ) ||
                route.highlights.any(
                  (highlight) => highlight.toLowerCase().contains(
                    searchQuery.toLowerCase(),
                  ),
                ),
          )
          .toList();
    }

    return routes;
  }

  List<RouteItem> _getMockData() {
    return [
      RouteItem(
        id: '1',
        name: 'Aukruger Naturpfad',
        description:
            'Ein wunderschöner Rundweg durch den Naturpark Aukrug mit herrlichen Ausblicken und vielfältiger Flora.',
        distance: 8.5,
        duration: const Duration(hours: 2, minutes: 30),
        difficulty: RouteDifficulty.leicht,
        type: RouteType.wandern,
        waypoints: const [
          RoutePoint(
            lat: 54.0833,
            lng: 9.75,
            name: 'Start: Parkplatz Naturpark',
          ),
          RoutePoint(lat: 54.085, lng: 9.755, name: 'Aussichtspunkt Hügel'),
          RoutePoint(lat: 54.090, lng: 9.745, name: 'Waldlichtung'),
          RoutePoint(lat: 54.088, lng: 9.735, name: 'Teich'),
          RoutePoint(lat: 54.0833, lng: 9.75, name: 'Ziel: Parkplatz'),
        ],
        highlights: [
          'Aussichtspunkt',
          'Waldlichtung',
          'Naturteich',
          'Wildtiere',
        ],
        imageUrls: [
          'https://via.placeholder.com/400x300/4CAF50/white?text=Naturpfad+1',
          'https://via.placeholder.com/400x300/8BC34A/white?text=Naturpfad+2',
        ],
        downloadUrl: 'https://example.com/routes/aukruger-naturpfad.gpx',
      ),
      RouteItem(
        id: '2',
        name: 'Radtour um Aukrug',
        description:
            'Gemütliche Radtour durch die Dörfer rund um Aukrug mit Einkehrmöglichkeiten und kulturellen Highlights.',
        distance: 22.0,
        duration: const Duration(hours: 3, minutes: 45),
        difficulty: RouteDifficulty.mittel,
        type: RouteType.radfahren,
        waypoints: const [
          RoutePoint(lat: 54.0833, lng: 9.75, name: 'Start: Aukrug Zentrum'),
          RoutePoint(lat: 54.1, lng: 9.8, name: 'Gut Altenkrempe'),
          RoutePoint(lat: 54.095, lng: 9.82, name: 'Dorf Bornholt'),
          RoutePoint(lat: 54.070, lng: 9.785, name: 'Gasthof Zur Linde'),
          RoutePoint(lat: 54.0833, lng: 9.75, name: 'Ziel: Aukrug Zentrum'),
        ],
        highlights: [
          'Gut Altenkrempe',
          'Dorfkerne',
          'Gasthof',
          'Kulturlandschaft',
        ],
        imageUrls: [
          'https://via.placeholder.com/400x300/2196F3/white?text=Radtour+1',
          'https://via.placeholder.com/400x300/03A9F4/white?text=Radtour+2',
        ],
        downloadUrl: 'https://example.com/routes/radtour-um-aukrug.gpx',
      ),
      RouteItem(
        id: '3',
        name: 'Joggingrunde Aukruger Wald',
        description:
            'Perfekte Laufstrecke für Läufer durch abwechslungsreiche Waldwege mit verschiedenen Schwierigkeitsgraden.',
        distance: 5.2,
        duration: const Duration(minutes: 45),
        difficulty: RouteDifficulty.mittel,
        type: RouteType.laufen,
        waypoints: const [
          RoutePoint(lat: 54.085, lng: 9.745, name: 'Start: Waldparkplatz'),
          RoutePoint(lat: 54.090, lng: 9.740, name: 'Steiler Anstieg'),
          RoutePoint(lat: 54.092, lng: 9.750, name: 'Waldkreuzung'),
          RoutePoint(lat: 54.088, lng: 9.752, name: 'Abstieg'),
          RoutePoint(lat: 54.085, lng: 9.745, name: 'Ziel: Waldparkplatz'),
        ],
        highlights: ['Waldwege', 'Steigungen', 'Naturerlebnis', 'Ruhe'],
        imageUrls: [
          'https://via.placeholder.com/400x300/FF5722/white?text=Jogging+1',
        ],
        downloadUrl: 'https://example.com/routes/joggingrunde-wald.gpx',
      ),
      RouteItem(
        id: '4',
        name: 'Nordic Walking Gesundheitspfad',
        description:
            'Speziell für Nordic Walking ausgelegter Pfad mit Übungsstationen und gesundheitsfördernden Elementen.',
        distance: 6.8,
        duration: const Duration(hours: 1, minutes: 30),
        difficulty: RouteDifficulty.leicht,
        type: RouteType.nordic_walking,
        waypoints: const [
          RoutePoint(
            lat: 54.080,
            lng: 9.760,
            name: 'Start: Gesundheitszentrum',
          ),
          RoutePoint(lat: 54.083, lng: 9.765, name: 'Übungsstation 1'),
          RoutePoint(lat: 54.087, lng: 9.770, name: 'Aussichtspunkt'),
          RoutePoint(lat: 54.085, lng: 9.775, name: 'Übungsstation 2'),
          RoutePoint(lat: 54.080, lng: 9.760, name: 'Ziel: Gesundheitszentrum'),
        ],
        highlights: [
          'Übungsstationen',
          'Gesundheit',
          'Aussichten',
          'Entspannung',
        ],
        imageUrls: [
          'https://via.placeholder.com/400x300/9C27B0/white?text=Nordic+Walking',
        ],
        downloadUrl: 'https://example.com/routes/nordic-walking-pfad.gpx',
      ),
      RouteItem(
        id: '5',
        name: 'Herausforderung Aukruger Höhen',
        description:
            'Anspruchsvolle Wanderung zu den höchsten Punkten der Region mit spektakulären Ausblicken.',
        distance: 12.5,
        duration: const Duration(hours: 4, minutes: 15),
        difficulty: RouteDifficulty.schwer,
        type: RouteType.wandern,
        waypoints: const [
          RoutePoint(lat: 54.078, lng: 9.740, name: 'Start: Wanderparkplatz'),
          RoutePoint(lat: 54.095, lng: 9.725, name: 'Erster Gipfel'),
          RoutePoint(lat: 54.105, lng: 9.715, name: 'Höchster Punkt'),
          RoutePoint(lat: 54.100, lng: 9.735, name: 'Berghütte'),
          RoutePoint(lat: 54.090, lng: 9.745, name: 'Abstieg'),
          RoutePoint(lat: 54.078, lng: 9.740, name: 'Ziel: Wanderparkplatz'),
        ],
        highlights: [
          'Gipfelaussichten',
          'Berghütte',
          'Herausforderung',
          'Panorama',
        ],
        imageUrls: [
          'https://via.placeholder.com/400x300/795548/white?text=Gipfel+1',
          'https://via.placeholder.com/400x300/8D6E63/white?text=Gipfel+2',
        ],
        downloadUrl: 'https://example.com/routes/aukruger-hoehen.gpx',
        elevationProfile:
            'https://example.com/routes/elevation-aukruger-hoehen.svg',
      ),
    ];
  }
}
