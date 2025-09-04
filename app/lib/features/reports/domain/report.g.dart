// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReportImpl _$$ReportImplFromJson(Map<String, dynamic> json) => _$ReportImpl(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      description: json['description'] as String,
      category: $enumDecode(_$ReportCategoryEnumMap, json['category']),
      priority: $enumDecode(_$ReportPriorityEnumMap, json['priority']),
      status: $enumDecode(_$ReportStatusEnumMap, json['status']),
      location:
          ReportLocation.fromJson(json['location'] as Map<String, dynamic>),
      imageUrls: (json['imageUrls'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      contactName: json['contactName'] as String?,
      contactEmail: json['contactEmail'] as String?,
      contactPhone: json['contactPhone'] as String?,
      isAnonymous: json['isAnonymous'] as bool? ?? false,
      submittedAt: json['submittedAt'] == null
          ? null
          : DateTime.parse(json['submittedAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      municipalityResponse: json['municipalityResponse'] as String?,
      responseAt: json['responseAt'] == null
          ? null
          : DateTime.parse(json['responseAt'] as String),
      referenceNumber: json['referenceNumber'] as String?,
    );

Map<String, dynamic> _$$ReportImplToJson(_$ReportImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'category': _$ReportCategoryEnumMap[instance.category]!,
      'priority': _$ReportPriorityEnumMap[instance.priority]!,
      'status': _$ReportStatusEnumMap[instance.status]!,
      'location': instance.location,
      'imageUrls': instance.imageUrls,
      'contactName': instance.contactName,
      'contactEmail': instance.contactEmail,
      'contactPhone': instance.contactPhone,
      'isAnonymous': instance.isAnonymous,
      'submittedAt': instance.submittedAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'municipalityResponse': instance.municipalityResponse,
      'responseAt': instance.responseAt?.toIso8601String(),
      'referenceNumber': instance.referenceNumber,
    };

const _$ReportCategoryEnumMap = {
  ReportCategory.roadsTraffic: 'roads_traffic',
  ReportCategory.publicLighting: 'public_lighting',
  ReportCategory.wasteManagement: 'waste_management',
  ReportCategory.parksGreenSpaces: 'parks_green_spaces',
  ReportCategory.waterDrainage: 'water_drainage',
  ReportCategory.publicFacilities: 'public_facilities',
  ReportCategory.vandalism: 'vandalism',
  ReportCategory.environmental: 'environmental',
  ReportCategory.accessibility: 'accessibility',
  ReportCategory.other: 'other',
};

const _$ReportPriorityEnumMap = {
  ReportPriority.low: 'low',
  ReportPriority.medium: 'medium',
  ReportPriority.high: 'high',
  ReportPriority.urgent: 'urgent',
};

const _$ReportStatusEnumMap = {
  ReportStatus.submitted: 'submitted',
  ReportStatus.received: 'received',
  ReportStatus.inProgress: 'in_progress',
  ReportStatus.resolved: 'resolved',
  ReportStatus.closed: 'closed',
  ReportStatus.rejected: 'rejected',
};

_$ReportLocationImpl _$$ReportLocationImplFromJson(Map<String, dynamic> json) =>
    _$ReportLocationImpl(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      address: json['address'] as String?,
      description: json['description'] as String?,
      landmark: json['landmark'] as String?,
    );

Map<String, dynamic> _$$ReportLocationImplToJson(
        _$ReportLocationImpl instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'address': instance.address,
      'description': instance.description,
      'landmark': instance.landmark,
    };
