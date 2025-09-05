import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/error/app_error.dart';
import '../domain/document.dart';

part 'documents_repository.g.dart';

@riverpod
DocumentsRepository documentsRepository(DocumentsRepositoryRef ref) {
  return DocumentsRepository();
}

/// Repository for managing municipal documents and downloads
class DocumentsRepository {
  List<Document>? _cachedDocuments;

  /// Get all documents from fixtures
  Future<List<Document>> getAllDocuments() async {
    try {
      if (_cachedDocuments != null) {
        return _cachedDocuments!;
      }

      final String response = await rootBundle.loadString(
        'assets/fixtures/documents.json',
      );
      final Map<String, dynamic> data = json.decode(response);
      final List<dynamic> documentsJson = data['documents'];

      _cachedDocuments = documentsJson
          .map((json) => Document.fromJson(json as Map<String, dynamic>))
          .toList();

      return _cachedDocuments!;
    } catch (e) {
      throw AppError.storage('Fehler beim Laden der Dokumente: $e');
    }
  }

  /// Get popular documents only
  Future<List<Document>> getPopularDocuments() async {
    final allDocs = await getAllDocuments();
    return allDocs.where((doc) => doc.isPopular).toList();
  }

  /// Get documents by category
  Future<List<Document>> getDocumentsByCategory(
    DocumentCategory category,
  ) async {
    final allDocs = await getAllDocuments();
    return allDocs.where((doc) => doc.category == category).toList();
  }

  /// Search documents by title, description, or tags
  Future<List<Document>> searchDocuments(String query) async {
    if (query.isEmpty) return [];

    final allDocs = await getAllDocuments();
    final lowerQuery = query.toLowerCase();

    return allDocs.where((doc) {
      // Search in title
      if (doc.title.toLowerCase().contains(lowerQuery)) return true;

      // Search in description
      if (doc.description.toLowerCase().contains(lowerQuery)) return true;

      // Search in tags
      if (doc.tags?.any((tag) => tag.toLowerCase().contains(lowerQuery)) ==
          true)
        return true;

      return false;
    }).toList();
  }

  /// Get document by ID
  Future<Document?> getDocumentById(int id) async {
    final allDocs = await getAllDocuments();
    try {
      return allDocs.firstWhere((doc) => doc.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Clear cache (useful for testing or refresh)
  void clearCache() {
    _cachedDocuments = null;
  }
}
