import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

// Plattform-abhängige Imports
import 'package:isar/isar.dart' if (dart.library.html) 'web_isar_stub.dart';
import '../features/reports/data/report_cache_entity.dart' if (dart.library.html) 'web_entity_stub.dart';
import 'storage/web_storage_service.dart' if (dart.library.io) 'storage_stub.dart';

/// Plattform-adaptiver Storage-Service
class PlatformStorageService {
  Isar? _isar;
  
  /// Initialisiere Storage je nach Plattform
  Future<void> initialize() async {
    if (kIsWeb) {
      // Web: Nutze localStorage
      print('Storage: Web-Modus aktiviert (LocalStorage)');
    } else {
      // Mobile/Desktop: Nutze Isar
      try {
        _isar = await Isar.open([ReportCacheEntitySchema]);
        print('Storage: Isar-Datenbank geöffnet');
      } catch (e) {
        print('Storage: Isar-Fehler: $e');
      }
    }
  }
  
  /// Speichere Reports plattformspezifisch
  Future<void> saveReports(List<Map<String, dynamic>> reports) async {
    if (kIsWeb) {
      await WebStorageService.saveReports(reports);
    } else if (_isar != null) {
      await _isar!.writeTxn(() async {
        await _isar!.reportCacheEntitys.clear();
        for (final report in reports) {
          final entity = ReportCacheEntity()
            ..reportId = report['id'] ?? ''
            ..title = report['title'] ?? ''
            ..description = report['description'] ?? ''
            ..status = report['status'] ?? ''
            ..priority = report['priority'] ?? ''
            ..category = report['category'] ?? ''
            ..location = report['location'] ?? ''
            ..imageUrls = (report['imageUrls'] as List?)?.cast<String>() ?? []
            ..createdAt = DateTime.tryParse(report['createdAt'] ?? '') ?? DateTime.now()
            ..updatedAt = DateTime.tryParse(report['updatedAt'] ?? '') ?? DateTime.now();
          await _isar!.reportCacheEntitys.put(entity);
        }
      });
    }
  }
  
  /// Lade Reports plattformspezifisch
  Future<List<Map<String, dynamic>>> loadReports() async {
    if (kIsWeb) {
      return await WebStorageService.loadReports();
    } else if (_isar != null) {
      final entities = await _isar!.reportCacheEntitys.where().findAll();
      return entities.map((entity) => {
        'id': entity.reportId,
        'title': entity.title,
        'description': entity.description,
        'status': entity.status,
        'priority': entity.priority,
        'category': entity.category,
        'location': entity.location,
        'imageUrls': entity.imageUrls,
        'createdAt': entity.createdAt.toIso8601String(),
        'updatedAt': entity.updatedAt.toIso8601String(),
      }).toList();
    }
    return [];
  }
  
  /// Lösche alle Reports
  Future<void> clearReports() async {
    if (kIsWeb) {
      await WebStorageService.clearReports();
    } else if (_isar != null) {
      await _isar!.writeTxn(() async {
        await _isar!.reportCacheEntitys.clear();
      });
    }
  }
}
