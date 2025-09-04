import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/documents_repository.dart';
import '../domain/document.dart';

part 'documents_provider.g.dart';

@riverpod
DocumentsRepository documentsRepository(DocumentsRepositoryRef ref) {
  return DocumentsRepository();
}

@riverpod
Future<List<Document>> allDocuments(AllDocumentsRef ref) async {
  final repository = ref.watch(documentsRepositoryProvider);
  return repository.getAllDocuments();
}

@riverpod
Future<List<Document>> popularDocuments(PopularDocumentsRef ref) async {
  final repository = ref.watch(documentsRepositoryProvider);
  return repository.getPopularDocuments();
}

@riverpod
Future<List<Document>> documentsByCategory(
  DocumentsByCategoryRef ref,
  DocumentCategory category,
) async {
  final repository = ref.watch(documentsRepositoryProvider);
  return repository.getDocumentsByCategory(category);
}

@riverpod
class DocumentsSearch extends _$DocumentsSearch {
  @override
  Future<List<Document>> build() async {
    return [];
  }

  Future<void> search(String query) async {
    if (query.isEmpty) {
      state = const AsyncValue.data([]);
      return;
    }

    state = const AsyncValue.loading();

    try {
      final repository = ref.read(documentsRepositoryProvider);
      final results = await repository.searchDocuments(query);
      state = AsyncValue.data(results);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  void clear() {
    state = const AsyncValue.data([]);
  }
}
