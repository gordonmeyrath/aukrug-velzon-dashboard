import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kMapViewPrefsKey = 'map_view_prefs_v1';

class MapViewPrefs {
  final double centerLat;
  final double centerLng;
  final double zoom;
  const MapViewPrefs({
    required this.centerLat,
    required this.centerLng,
    required this.zoom,
  });

  LatLng get center => LatLng(centerLat, centerLng);

  Map<String, dynamic> toJson() => {
    'lat': centerLat,
    'lng': centerLng,
    'z': zoom,
  };

  factory MapViewPrefs.fromJson(Map<String, dynamic> json) => MapViewPrefs(
    centerLat: (json['lat'] as num?)?.toDouble() ?? 54.1333,
    centerLng: (json['lng'] as num?)?.toDouble() ?? 9.8833,
    zoom: (json['z'] as num?)?.toDouble() ?? 13.0,
  );

  MapViewPrefs copyWith({double? centerLat, double? centerLng, double? zoom}) =>
      MapViewPrefs(
        centerLat: centerLat ?? this.centerLat,
        centerLng: centerLng ?? this.centerLng,
        zoom: zoom ?? this.zoom,
      );

  static MapViewPrefs initial() =>
      const MapViewPrefs(centerLat: 54.1333, centerLng: 9.8833, zoom: 13.0);
}

final mapViewPrefsProvider = FutureProvider<MapViewPrefs>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  final raw = prefs.getString(_kMapViewPrefsKey);
  if (raw == null) return MapViewPrefs.initial();
  try {
    return MapViewPrefs.fromJson(json.decode(raw) as Map<String, dynamic>);
  } catch (_) {
    return MapViewPrefs.initial();
  }
});

class MapViewPrefsService {
  MapViewPrefsService(this._prefs);
  final SharedPreferences _prefs;
  Future<void> save(MapViewPrefs prefs) async {
    await _prefs.setString(_kMapViewPrefsKey, json.encode(prefs.toJson()));
  }
}

final mapViewPrefsServiceProvider = FutureProvider<MapViewPrefsService>((
  ref,
) async {
  final prefs = await SharedPreferences.getInstance();
  return MapViewPrefsService(prefs);
});
