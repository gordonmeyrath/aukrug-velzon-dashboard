import 'dart:io' show Platform;

import 'package:isar/isar.dart';
import '../../reports/domain/report.dart';

// Conditional import based on platform
import 'package:flutter/foundation.dart' show kIsWeb;

part 'report_cache_entity.g.dart';

/// Persistenter Offline-Cache für Reports
/// Web-kompatible Version ohne Isar-JavaScript-Probleme
@Collection()
class ReportCacheEntity {
  /// Web-kompatible ID-Generation
  @Id()
  int get id {
    if (kIsWeb) {
      // Für Web: Verwende kleinere, sichere Integer-IDs
      return DateTime.now().millisecondsSinceEpoch % 2147483647; // Safe JS int
    } else {
      // Für Mobile: Isar.autoIncrement
      return Isar.autoIncrement;
    }
  }
  
  set id(int value) {
    // Setter für Isar-Kompatibilität
  }

  late String title;
  late String description;
  int categoryIndex; // enum index
  int priorityIndex;
  int statusIndex;
  double latitude;
  double longitude;
  String? address;
  DateTime? submittedAt;
  DateTime? updatedAt;
  String? referenceNumber;
  bool isAnonymous;
  String? contactName;
  String? contactEmail;
  String? contactPhone;
  List<String>? imageUrls; // stored as list

  ReportCacheEntity({
    required this.title,
    required this.description,
    required this.categoryIndex,
    required this.priorityIndex,
    required this.statusIndex,
    required this.latitude,
    required this.longitude,
    this.address,
    this.submittedAt,
    this.updatedAt,
    this.referenceNumber,
    this.isAnonymous = false,
    this.contactName,
    this.contactEmail,
    this.contactPhone,
    this.imageUrls,
  });
}

/// Mapping extensions für Konversion zwischen Domain und Entity
extension ReportCacheEntityMapping on ReportCacheEntity {
  Report toReport() => Report(
    id: id,
    title: title,
    description: description,
    category: ReportCategory.values[categoryIndex],
    priority: ReportPriority.values[priorityIndex],
    status: ReportStatus.values[statusIndex],
    location: ReportLocation(
      latitude: latitude,
      longitude: longitude,
      address: address,
    ),
    imageUrls: imageUrls,
    contactName: contactName,
    contactEmail: contactEmail,
    contactPhone: contactPhone,
    isAnonymous: isAnonymous,
    submittedAt: submittedAt,
    updatedAt: updatedAt,
    referenceNumber: referenceNumber,
  );
}

extension ReportToCacheEntity on Report {
  ReportCacheEntity toCacheEntity() => ReportCacheEntity(
    title: title,
    description: description,
    categoryIndex: category.index,
    priorityIndex: priority.index,
    statusIndex: status.index,
    latitude: location.latitude,
    longitude: location.longitude,
    address: location.address,
    imageUrls: imageUrls,
    contactName: contactName,
    contactEmail: contactEmail,
    contactPhone: contactPhone,
    isAnonymous: isAnonymous,
    submittedAt: submittedAt,
    updatedAt: updatedAt,
    referenceNumber: referenceNumber,
  );
}
