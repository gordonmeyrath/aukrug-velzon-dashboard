// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_verification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TemporaryVerificationDataImpl _$$TemporaryVerificationDataImplFromJson(
        Map<String, dynamic> json) =>
    _$TemporaryVerificationDataImpl(
      fullName: json['fullName'] as String,
      address: json['address'] as String,
      zipCode: json['zipCode'] as String,
      city: json['city'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      scheduledDeletionAt:
          DateTime.parse(json['scheduledDeletionAt'] as String),
      consentHash: json['consentHash'] as String,
      consentGivenAt: DateTime.parse(json['consentGivenAt'] as String),
      phoneNumber: json['phoneNumber'] as String?,
      documentType: json['documentType'] as String?,
      documentNumber: json['documentNumber'] as String?,
      additionalInfo: json['additionalInfo'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$TemporaryVerificationDataImplToJson(
        _$TemporaryVerificationDataImpl instance) =>
    <String, dynamic>{
      'fullName': instance.fullName,
      'address': instance.address,
      'zipCode': instance.zipCode,
      'city': instance.city,
      'createdAt': instance.createdAt.toIso8601String(),
      'scheduledDeletionAt': instance.scheduledDeletionAt.toIso8601String(),
      'consentHash': instance.consentHash,
      'consentGivenAt': instance.consentGivenAt.toIso8601String(),
      'phoneNumber': instance.phoneNumber,
      'documentType': instance.documentType,
      'documentNumber': instance.documentNumber,
      'additionalInfo': instance.additionalInfo,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };

_$VerificationAuditEntryImpl _$$VerificationAuditEntryImplFromJson(
        Map<String, dynamic> json) =>
    _$VerificationAuditEntryImpl(
      id: json['id'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      action: $enumDecode(_$VerificationActionEnumMap, json['action']),
      performedBy: json['performedBy'] as String,
      reason: json['reason'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$VerificationAuditEntryImplToJson(
        _$VerificationAuditEntryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'timestamp': instance.timestamp.toIso8601String(),
      'action': _$VerificationActionEnumMap[instance.action]!,
      'performedBy': instance.performedBy,
      'reason': instance.reason,
      'metadata': instance.metadata,
    };

const _$VerificationActionEnumMap = {
  VerificationAction.submitted: 'submitted',
  VerificationAction.locationTrackingStarted: 'locationTrackingStarted',
  VerificationAction.locationCheckPerformed: 'locationCheckPerformed',
  VerificationAction.locationCheckSuccess: 'locationCheckSuccess',
  VerificationAction.locationCheckFailed: 'locationCheckFailed',
  VerificationAction.verificationThresholdMet: 'verificationThresholdMet',
  VerificationAction.reviewed: 'reviewed',
  VerificationAction.additionalInfoRequested: 'additionalInfoRequested',
  VerificationAction.additionalInfoProvided: 'additionalInfoProvided',
  VerificationAction.approved: 'approved',
  VerificationAction.rejected: 'rejected',
  VerificationAction.dataDeleted: 'dataDeleted',
  VerificationAction.expired: 'expired',
};

_$ResidentVerificationImpl _$$ResidentVerificationImplFromJson(
        Map<String, dynamic> json) =>
    _$ResidentVerificationImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      status: $enumDecode(_$VerificationStatusEnumMap, json['status']),
      submittedAt: DateTime.parse(json['submittedAt'] as String),
      dataWillBeDeletedAt:
          DateTime.parse(json['dataWillBeDeletedAt'] as String),
      auditTrail: (json['auditTrail'] as List<dynamic>)
          .map(
              (e) => VerificationAuditEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
      temporaryData: json['temporaryData'] == null
          ? null
          : TemporaryVerificationData.fromJson(
              json['temporaryData'] as Map<String, dynamic>),
      verifiedAt: json['verifiedAt'] == null
          ? null
          : DateTime.parse(json['verifiedAt'] as String),
      adminNotes: json['adminNotes'] as String?,
      rejectionReason: json['rejectionReason'] as String?,
    );

Map<String, dynamic> _$$ResidentVerificationImplToJson(
        _$ResidentVerificationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'status': _$VerificationStatusEnumMap[instance.status]!,
      'submittedAt': instance.submittedAt.toIso8601String(),
      'dataWillBeDeletedAt': instance.dataWillBeDeletedAt.toIso8601String(),
      'auditTrail': instance.auditTrail,
      'temporaryData': instance.temporaryData,
      'verifiedAt': instance.verifiedAt?.toIso8601String(),
      'adminNotes': instance.adminNotes,
      'rejectionReason': instance.rejectionReason,
    };

const _$VerificationStatusEnumMap = {
  VerificationStatus.pending: 'pending',
  VerificationStatus.locationTracking: 'locationTracking',
  VerificationStatus.inReview: 'inReview',
  VerificationStatus.additionalInfoRequired: 'additionalInfoRequired',
  VerificationStatus.verified: 'verified',
  VerificationStatus.rejected: 'rejected',
  VerificationStatus.expired: 'expired',
  VerificationStatus.dataDeleted: 'dataDeleted',
};

_$ConsentAuditEntryImpl _$$ConsentAuditEntryImplFromJson(
        Map<String, dynamic> json) =>
    _$ConsentAuditEntryImpl(
      id: json['id'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      action: $enumDecode(_$ConsentActionEnumMap, json['action']),
      source: $enumDecode(_$ConsentSourceEnumMap, json['source']),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$ConsentAuditEntryImplToJson(
        _$ConsentAuditEntryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'timestamp': instance.timestamp.toIso8601String(),
      'action': _$ConsentActionEnumMap[instance.action]!,
      'source': _$ConsentSourceEnumMap[instance.source]!,
      'metadata': instance.metadata,
    };

const _$ConsentActionEnumMap = {
  ConsentAction.granted: 'granted',
  ConsentAction.withdrawn: 'withdrawn',
  ConsentAction.renewed: 'renewed',
  ConsentAction.modified: 'modified',
  ConsentAction.expired: 'expired',
  ConsentAction.imported: 'imported',
};

const _$ConsentSourceEnumMap = {
  ConsentSource.userInterface: 'userInterface',
  ConsentSource.webForm: 'webForm',
  ConsentSource.mobileApp: 'mobileApp',
  ConsentSource.apiCall: 'apiCall',
  ConsentSource.adminPanel: 'adminPanel',
  ConsentSource.importedData: 'importedData',
  ConsentSource.migrationProcess: 'migrationProcess',
};

_$DataProcessingConsentImpl _$$DataProcessingConsentImplFromJson(
        Map<String, dynamic> json) =>
    _$DataProcessingConsentImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      consentType: $enumDecode(_$ConsentTypeEnumMap, json['consentType']),
      granted: json['granted'] as bool,
      grantedAt: DateTime.parse(json['grantedAt'] as String),
      source: $enumDecode(_$ConsentSourceEnumMap, json['source']),
      purpose: json['purpose'] as String,
      legalBasis: json['legalBasis'] as String,
      validUntil: DateTime.parse(json['validUntil'] as String),
      ipAddress: json['ipAddress'] as String,
      userAgent: json['userAgent'] as String,
      consentVersion: json['consentVersion'] as String,
      metadata: json['metadata'] as Map<String, dynamic>,
      auditTrail: (json['auditTrail'] as List<dynamic>)
          .map((e) => ConsentAuditEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
      withdrawnAt: json['withdrawnAt'] == null
          ? null
          : DateTime.parse(json['withdrawnAt'] as String),
      renewedAt: json['renewedAt'] == null
          ? null
          : DateTime.parse(json['renewedAt'] as String),
    );

Map<String, dynamic> _$$DataProcessingConsentImplToJson(
        _$DataProcessingConsentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'consentType': _$ConsentTypeEnumMap[instance.consentType]!,
      'granted': instance.granted,
      'grantedAt': instance.grantedAt.toIso8601String(),
      'source': _$ConsentSourceEnumMap[instance.source]!,
      'purpose': instance.purpose,
      'legalBasis': instance.legalBasis,
      'validUntil': instance.validUntil.toIso8601String(),
      'ipAddress': instance.ipAddress,
      'userAgent': instance.userAgent,
      'consentVersion': instance.consentVersion,
      'metadata': instance.metadata,
      'auditTrail': instance.auditTrail,
      'withdrawnAt': instance.withdrawnAt?.toIso8601String(),
      'renewedAt': instance.renewedAt?.toIso8601String(),
    };

const _$ConsentTypeEnumMap = {
  ConsentType.residentVerification: 'residentVerification',
  ConsentType.dataProcessing: 'dataProcessing',
  ConsentType.locationTracking: 'locationTracking',
  ConsentType.photoUpload: 'photoUpload',
  ConsentType.reportSubmission: 'reportSubmission',
  ConsentType.newsletter: 'newsletter',
  ConsentType.analytics: 'analytics',
  ConsentType.thirdPartySharing: 'thirdPartySharing',
};

_$DataAccessRequestImpl _$$DataAccessRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$DataAccessRequestImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      requestType: $enumDecode(_$DataAccessTypeEnumMap, json['requestType']),
      requestedAt: DateTime.parse(json['requestedAt'] as String),
      status: $enumDecode(_$DataAccessStatusEnumMap, json['status']),
      processedAt: json['processedAt'] == null
          ? null
          : DateTime.parse(json['processedAt'] as String),
      responseData: json['responseData'] as String?,
      processingNotes: json['processingNotes'] as String?,
    );

Map<String, dynamic> _$$DataAccessRequestImplToJson(
        _$DataAccessRequestImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'requestType': _$DataAccessTypeEnumMap[instance.requestType]!,
      'requestedAt': instance.requestedAt.toIso8601String(),
      'status': _$DataAccessStatusEnumMap[instance.status]!,
      'processedAt': instance.processedAt?.toIso8601String(),
      'responseData': instance.responseData,
      'processingNotes': instance.processingNotes,
    };

const _$DataAccessTypeEnumMap = {
  DataAccessType.export: 'export',
  DataAccessType.deletion: 'deletion',
  DataAccessType.correction: 'correction',
  DataAccessType.information: 'information',
  DataAccessType.restriction: 'restriction',
};

const _$DataAccessStatusEnumMap = {
  DataAccessStatus.pending: 'pending',
  DataAccessStatus.processing: 'processing',
  DataAccessStatus.completed: 'completed',
  DataAccessStatus.rejected: 'rejected',
};

_$LocationCheckImpl _$$LocationCheckImplFromJson(Map<String, dynamic> json) =>
    _$LocationCheckImpl(
      id: json['id'] as String,
      verificationId: json['verificationId'] as String,
      checkTime: DateTime.parse(json['checkTime'] as String),
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      accuracy: (json['accuracy'] as num).toDouble(),
      isAtAddress: json['isAtAddress'] as bool,
      distanceToAddress: (json['distanceToAddress'] as num).toDouble(),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$LocationCheckImplToJson(_$LocationCheckImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'verificationId': instance.verificationId,
      'checkTime': instance.checkTime.toIso8601String(),
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'accuracy': instance.accuracy,
      'isAtAddress': instance.isAtAddress,
      'distanceToAddress': instance.distanceToAddress,
      'metadata': instance.metadata,
    };

_$LocationTrackingSummaryImpl _$$LocationTrackingSummaryImplFromJson(
        Map<String, dynamic> json) =>
    _$LocationTrackingSummaryImpl(
      verificationId: json['verificationId'] as String,
      trackingStarted: DateTime.parse(json['trackingStarted'] as String),
      trackingEnded: DateTime.parse(json['trackingEnded'] as String),
      totalNights: (json['totalNights'] as num).toInt(),
      successfulNights: (json['successfulNights'] as num).toInt(),
      requiredNights: (json['requiredNights'] as num).toInt(),
      thresholdMet: json['thresholdMet'] as bool,
      checks: (json['checks'] as List<dynamic>)
          .map((e) => LocationCheck.fromJson(e as Map<String, dynamic>))
          .toList(),
      statistics: json['statistics'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$$LocationTrackingSummaryImplToJson(
        _$LocationTrackingSummaryImpl instance) =>
    <String, dynamic>{
      'verificationId': instance.verificationId,
      'trackingStarted': instance.trackingStarted.toIso8601String(),
      'trackingEnded': instance.trackingEnded.toIso8601String(),
      'totalNights': instance.totalNights,
      'successfulNights': instance.successfulNights,
      'requiredNights': instance.requiredNights,
      'thresholdMet': instance.thresholdMet,
      'checks': instance.checks,
      'statistics': instance.statistics,
    };
