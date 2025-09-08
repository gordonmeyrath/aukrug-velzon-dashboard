import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_verification.freezed.dart';
part 'user_verification.g.dart';

/// DSGVO-konforme Resident Verification Models
/// Implementiert Privacy-by-Design für temporäre Datenhaltung

/// Verification status für Dorfbewohner
enum VerificationStatus {
  pending, // Antrag eingereicht, wartet auf Bearbeitung
  locationTracking, // Geolokalisierungs-Überwachung läuft (7 Tage)
  inReview, // Wird vom Administrator geprüft
  additionalInfoRequired, // Zusätzliche Informationen benötigt
  verified, // Erfolgreich verifiziert (4/7 Nächte an Adresse)
  rejected, // Abgelehnt
  expired, // Zeitablauf überschritten
  dataDeleted, // Temporäre Daten gelöscht (nach Verifikation)
}

/// Aktionen im Verifikationsprozess für Audit-Trail
enum VerificationAction {
  submitted, // Antrag eingereicht
  locationTrackingStarted, // Geolokalisierungs-Überwachung gestartet
  locationCheckPerformed, // Nächtliche Standortprüfung durchgeführt
  locationCheckSuccess, // Standortprüfung erfolgreich (an Adresse)
  locationCheckFailed, // Standortprüfung fehlgeschlagen (nicht an Adresse)
  verificationThresholdMet, // Schwellenwert erreicht (4/7 Nächte)
  reviewed, // Zur Überprüfung weitergeleitet
  additionalInfoRequested, // Zusätzliche Infos angefordert
  additionalInfoProvided, // Zusätzliche Infos bereitgestellt
  approved, // Genehmigt
  rejected, // Abgelehnt
  dataDeleted, // Daten gelöscht
  expired, // Abgelaufen
}

/// Art der Einwilligung für DSGVO-Compliance
enum ConsentType {
  residentVerification, // Bewohner-Verifikation
  dataProcessing, // Allgemeine Datenverarbeitung
  locationTracking, // Standortverfolgung
  photoUpload, // Foto-Upload
  reportSubmission, // Meldungs-Übermittlung
  newsletter, // Newsletter-Versand
  analytics, // Analytics/Tracking
  thirdPartySharing, // Datenweitergabe an Dritte
}

/// Einwilligungsquelle für DSGVO-Audit
enum ConsentSource {
  userInterface,
  webForm,
  mobileApp,
  apiCall,
  adminPanel,
  importedData,
  migrationProcess,
}

/// Consent-Aktionen für Audit-Trail
enum ConsentAction { granted, withdrawn, renewed, modified, expired, imported }

/// Art der DSGVO-Datenanfrage
enum DataAccessType {
  export, // Recht auf Datenportabilität
  deletion, // Recht auf Löschung ("Recht auf Vergessenwerden")
  correction, // Recht auf Berichtigung
  information, // Recht auf Auskunft
  restriction, // Recht auf Einschränkung der Verarbeitung
}

/// Status der Datenanfrage
enum DataAccessStatus {
  pending, // Antrag eingegangen
  processing, // Wird bearbeitet
  completed, // Abgeschlossen
  rejected, // Abgelehnt
}

/// Temporäre Daten für Bewohner-Verifikation
/// Werden nach 7 Tagen automatisch gelöscht (DSGVO-konform)
@freezed
class TemporaryVerificationData with _$TemporaryVerificationData {
  const factory TemporaryVerificationData({
    required String fullName,
    required String address,
    required String zipCode,
    required String city,
    required DateTime createdAt,
    required DateTime scheduledDeletionAt,
    required String consentHash,
    required DateTime consentGivenAt,
    String? phoneNumber,
    String? documentType,
    String? documentNumber,
    String? additionalInfo,
    double? latitude,
    double? longitude,
  }) = _TemporaryVerificationData;

  factory TemporaryVerificationData.fromJson(Map<String, dynamic> json) =>
      _$TemporaryVerificationDataFromJson(json);
}

/// Audit-Eintrag für Verifikationsprozess
@freezed
class VerificationAuditEntry with _$VerificationAuditEntry {
  const factory VerificationAuditEntry({
    required String id,
    required DateTime timestamp,
    required VerificationAction action,
    required String performedBy,
    String? reason,
    Map<String, dynamic>? metadata,
  }) = _VerificationAuditEntry;

  factory VerificationAuditEntry.fromJson(Map<String, dynamic> json) =>
      _$VerificationAuditEntryFromJson(json);
}

/// Hauptmodel für Bewohner-Verifikation
@freezed
class ResidentVerification with _$ResidentVerification {
  const factory ResidentVerification({
    required String id,
    required String userId,
    required VerificationStatus status,
    required DateTime submittedAt,
    required DateTime dataWillBeDeletedAt,
    required List<VerificationAuditEntry> auditTrail,
    TemporaryVerificationData? temporaryData,
    DateTime? verifiedAt,
    String? adminNotes,
    String? rejectionReason,
  }) = _ResidentVerification;

  factory ResidentVerification.fromJson(Map<String, dynamic> json) =>
      _$ResidentVerificationFromJson(json);
}

/// Consent-Audit-Eintrag
@freezed
class ConsentAuditEntry with _$ConsentAuditEntry {
  const factory ConsentAuditEntry({
    required String id,
    required DateTime timestamp,
    required ConsentAction action,
    required ConsentSource source,
    Map<String, dynamic>? metadata,
  }) = _ConsentAuditEntry;

  factory ConsentAuditEntry.fromJson(Map<String, dynamic> json) =>
      _$ConsentAuditEntryFromJson(json);
}

/// Datenverarbeitungseinwilligung nach DSGVO
@freezed
class DataProcessingConsent with _$DataProcessingConsent {
  const factory DataProcessingConsent({
    required String id,
    required String userId,
    required ConsentType consentType,
    required bool granted,
    required DateTime grantedAt,
    required ConsentSource source,
    required String purpose,
    required String legalBasis,
    required DateTime validUntil,
    required String ipAddress,
    required String userAgent,
    required String consentVersion,
    required Map<String, dynamic> metadata,
    required List<ConsentAuditEntry> auditTrail,
    DateTime? withdrawnAt,
    DateTime? renewedAt,
  }) = _DataProcessingConsent;

  factory DataProcessingConsent.fromJson(Map<String, dynamic> json) =>
      _$DataProcessingConsentFromJson(json);
}

/// DSGVO Datenanfrage (Recht auf Datenportabilität)
@freezed
class DataAccessRequest with _$DataAccessRequest {
  const factory DataAccessRequest({
    required String id,
    required String userId,
    required DataAccessType requestType,
    required DateTime requestedAt,
    required DataAccessStatus status,
    DateTime? processedAt,
    String? responseData,
    String? processingNotes,
  }) = _DataAccessRequest;

  factory DataAccessRequest.fromJson(Map<String, dynamic> json) =>
      _$DataAccessRequestFromJson(json);
}

/// Geolokalisierungs-Check für nächtliche Verifikation
@freezed
class LocationCheck with _$LocationCheck {
  const factory LocationCheck({
    required String id,
    required String verificationId,
    required DateTime checkTime,
    required double latitude,
    required double longitude,
    required double accuracy,
    required bool isAtAddress,
    required double distanceToAddress,
    Map<String, dynamic>? metadata,
  }) = _LocationCheck;

  factory LocationCheck.fromJson(Map<String, dynamic> json) =>
      _$LocationCheckFromJson(json);
}

/// Zusammenfassung der wöchentlichen Geolokalisierungs-Überwachung
@freezed
class LocationTrackingSummary with _$LocationTrackingSummary {
  const factory LocationTrackingSummary({
    required String verificationId,
    required DateTime trackingStarted,
    required DateTime trackingEnded,
    required int totalNights,
    required int successfulNights,
    required int requiredNights,
    required bool thresholdMet,
    required List<LocationCheck> checks,
    required Map<String, dynamic> statistics,
  }) = _LocationTrackingSummary;

  factory LocationTrackingSummary.fromJson(Map<String, dynamic> json) =>
      _$LocationTrackingSummaryFromJson(json);
}
