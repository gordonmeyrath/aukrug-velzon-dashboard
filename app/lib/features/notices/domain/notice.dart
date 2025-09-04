import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'notice.freezed.dart';
part 'notice.g.dart';

/// Notice model for municipal announcements and important information
@freezed
class Notice with _$Notice {
  const factory Notice({
    required int id,
    required String title,
    required String content,
    required DateTime publishedDate,
    DateTime? validUntil,
    required NoticePriority priority,
    required String category,
    String? imageUrl,
    List<NoticeAttachment>? attachments,
    @Default([]) List<String> tags,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Notice;

  factory Notice.fromJson(Map<String, dynamic> json) => _$NoticeFromJson(json);
}

/// Attachment for notices (PDFs, images, etc.)
@freezed
class NoticeAttachment with _$NoticeAttachment {
  const factory NoticeAttachment({
    required String name,
    required String url,
    required String type,
    required int size,
  }) = _NoticeAttachment;

  factory NoticeAttachment.fromJson(Map<String, dynamic> json) => 
      _$NoticeAttachmentFromJson(json);
}

/// Priority levels for notices
enum NoticePriority {
  low,
  normal,
  high,
  urgent;

  String get displayName {
    switch (this) {
      case NoticePriority.low:
        return 'Niedrig';
      case NoticePriority.normal:
        return 'Normal';
      case NoticePriority.high:
        return 'Hoch';
      case NoticePriority.urgent:
        return 'Dringend';
    }
  }

  Color get color {
    switch (this) {
      case NoticePriority.low:
        return const Color(0xFF4CAF50); // Green
      case NoticePriority.normal:
        return const Color(0xFF2196F3); // Blue
      case NoticePriority.high:
        return const Color(0xFFFF9800); // Orange
      case NoticePriority.urgent:
        return const Color(0xFFF44336); // Red
    }
  }
}
