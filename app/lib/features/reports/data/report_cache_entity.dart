import 'package:isar/isar.dart';

import '../../reports/domain/report.dart';

part 'report_cache_entity.g.dart';

/// Persistenter Offline-Cache für Reports
@Collection()
class ReportCacheEntity {
  /// Primärschlüssel = Report-ID (bereits eindeutig)
  Id id = Isar.autoIncrement; // Kleinere, automatische IDs
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
    this.id = Isar.autoIncrement,
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
    required this.isAnonymous,
    this.contactName,
    this.contactEmail,
    this.contactPhone,
    this.imageUrls,
  });
}

extension ReportCacheEntityMapping on ReportCacheEntity {
  Report toDomain() => Report(
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

extension ReportToCache on Report {
  ReportCacheEntity toCacheEntity() => ReportCacheEntity(
    title: title,
    description: description,
    categoryIndex: category.index,
    priorityIndex: priority.index,
    statusIndex: status.index,
    latitude: location.latitude,
    longitude: location.longitude,
    address: location.address,
    submittedAt: submittedAt,
    updatedAt: updatedAt,
    referenceNumber: referenceNumber,
    isAnonymous: isAnonymous,
    contactName: contactName,
    contactEmail: contactEmail,
    contactPhone: contactPhone,
    imageUrls: imageUrls,
  );
}
