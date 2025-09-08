import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../domain/report.dart';
import '../presentation/reports_controller.dart';
import 'reports_repository.dart';

const _kReportsPrefsKey = 'reports_prefs_v1';
const _kReportsDeltaStatsKey = 'reports_delta_stats_v1';

class ReportsViewPrefs {
  final String query;
  final ReportCategory? category;
  final ReportStatus? status;
  final ReportsSort sort;
  final int staleMinutes; // 0 = niemals automatisch stale
  final DateTime? lastFullSyncAt; // für Delta-Sync
  final bool showOnlyNewSinceSync;

  const ReportsViewPrefs({
    required this.query,
    required this.category,
    required this.status,
    required this.sort,
    required this.staleMinutes,
    required this.lastFullSyncAt,
    required this.showOnlyNewSinceSync,
  });

  factory ReportsViewPrefs.initial() => const ReportsViewPrefs(
    query: '',
    category: null,
    status: null,
    sort: ReportsSort.latest,
    staleMinutes: 5,
    lastFullSyncAt: null,
    showOnlyNewSinceSync: false,
  );

  ReportsViewPrefs copyWith({
    String? query,
    ReportCategory? category = _noCatMarker,
    ReportStatus? status = _noStatusMarker,
    ReportsSort? sort,
    int? staleMinutes,
    DateTime? lastFullSyncAt,
    bool? showOnlyNewSinceSync,
  }) {
    return ReportsViewPrefs(
      query: query ?? this.query,
      category: category == _noCatMarker ? this.category : category,
      status: status == _noStatusMarker ? this.status : status,
      sort: sort ?? this.sort,
      staleMinutes: staleMinutes ?? this.staleMinutes,
      lastFullSyncAt: lastFullSyncAt ?? this.lastFullSyncAt,
      showOnlyNewSinceSync: showOnlyNewSinceSync ?? this.showOnlyNewSinceSync,
    );
  }

  Map<String, dynamic> toJson() => {
    'q': query,
    'c': category?.name,
    's': status?.name,
    'o': sort.name,
    'sm': staleMinutes,
    'ls': lastFullSyncAt?.toIso8601String(),
    'sn': showOnlyNewSinceSync,
  };

  factory ReportsViewPrefs.fromJson(Map<String, dynamic> json) {
    ReportCategory? cat;
    if (json['c'] is String) {
      cat = ReportCategory.values.firstWhere(
        (e) => e.name == json['c'],
        orElse: () => ReportCategory.other,
      );
    }
    ReportStatus? st;
    if (json['s'] is String) {
      st = ReportStatus.values.firstWhere(
        (e) => e.name == json['s'],
        orElse: () => ReportStatus.submitted,
      );
    }
    final sort = ReportsSort.values.firstWhere(
      (e) => e.name == json['o'],
      orElse: () => ReportsSort.latest,
    );
    final staleMinutes = (json['sm'] as num?)?.toInt() ?? 5;
    final lastFullSyncAt = json['ls'] is String
        ? DateTime.tryParse(json['ls'])
        : null;
    final showOnlyNewSinceSync = json['sn'] as bool? ?? false;
    return ReportsViewPrefs(
      query: json['q'] as String? ?? '',
      category: json['c'] == null ? null : cat,
      status: json['s'] == null ? null : st,
      sort: sort,
      staleMinutes: staleMinutes,
      lastFullSyncAt: lastFullSyncAt,
      showOnlyNewSinceSync: showOnlyNewSinceSync,
    );
  }
}

const _noCatMarker = ReportCategory.other; // marker
const _noStatusMarker = ReportStatus.submitted; // marker

final reportsViewPrefsProvider = FutureProvider<ReportsViewPrefs>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  final raw = prefs.getString(_kReportsPrefsKey);
  if (raw == null) return ReportsViewPrefs.initial();
  try {
    final map = json.decode(raw) as Map<String, dynamic>;
    return ReportsViewPrefs.fromJson(map);
  } catch (_) {
    return ReportsViewPrefs.initial();
  }
});

class ReportsPreferencesService {
  ReportsPreferencesService(this._prefs);
  final SharedPreferences _prefs;

  Future<void> save(ReportsViewPrefs p) async {
    await _prefs.setString(_kReportsPrefsKey, json.encode(p.toJson()));
  }

  Future<void> saveDeltaStats({
    required int added,
    required int updated,
    required int deleted,
    required DateTime at,
  }) async {
    final map = {
      'a': added,
      'u': updated,
      'd': deleted,
      't': at.toIso8601String(),
    };
    await _prefs.setString(_kReportsDeltaStatsKey, json.encode(map));
  }

  Map<String, dynamic>? loadDeltaStatsRaw() {
    final raw = _prefs.getString(_kReportsDeltaStatsKey);
    if (raw == null) return null;
    try {
      return json.decode(raw) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  DeltaStats? loadDeltaStats() {
    final map = loadDeltaStatsRaw();
    if (map == null) return null;
    try {
      final added = (map['a'] as num?)?.toInt() ?? 0;
      final updated = (map['u'] as num?)?.toInt() ?? 0;
      final deleted = (map['d'] as num?)?.toInt() ?? 0;
      return DeltaStats(added: added, updated: updated, deleted: deleted);
    } catch (_) {
      return null;
    }
  }
}

final reportsPreferencesServiceProvider =
    FutureProvider<ReportsPreferencesService>((ref) async {
      final prefs = await SharedPreferences.getInstance();
      return ReportsPreferencesService(prefs);
    });
