import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/app_error_widget.dart';
import '../../../core/widgets/loading_widget.dart';
import '../domain/document.dart';
import 'documents_provider.dart';
import 'widgets/document_card.dart';
import 'widgets/category_filter_chip.dart';

class DownloadsCenterPage extends ConsumerStatefulWidget {
  const DownloadsCenterPage({super.key});

  @override
  ConsumerState<DownloadsCenterPage> createState() =>
      _DownloadsCenterPageState();
}

class _DownloadsCenterPageState extends ConsumerState<DownloadsCenterPage> {
  final TextEditingController _searchController = TextEditingController();
  DocumentCategory? _selectedCategory;
  bool _showPopularOnly = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Downloads'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(120),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Suchfeld
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Dokumente durchsuchen...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              ref
                                  .read(documentsSearchProvider.notifier)
                                  .clear();
                              setState(() {});
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surface,
                  ),
                  onChanged: (value) {
                    setState(() {});
                    if (value.isNotEmpty) {
                      ref.read(documentsSearchProvider.notifier).search(value);
                    } else {
                      ref.read(documentsSearchProvider.notifier).clear();
                    }
                  },
                ),
                const SizedBox(height: 12),
                // Filter Chips
                SizedBox(
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      // Beliebte Dokumente Filter
                      FilterChip(
                        label: const Text('Beliebt'),
                        selected: _showPopularOnly,
                        onSelected: (selected) {
                          setState(() {
                            _showPopularOnly = selected;
                            if (selected) {
                              _selectedCategory = null;
                            }
                          });
                        },
                      ),
                      const SizedBox(width: 8),
                      // Kategorie Filter
                      ...DocumentCategory.values.map(
                        (category) => Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: CategoryFilterChip(
                            category: category,
                            isSelected: _selectedCategory == category,
                            onSelected: (selected) {
                              setState(() {
                                _selectedCategory = selected ? category : null;
                                if (selected) {
                                  _showPopularOnly = false;
                                }
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    // Wenn Suche aktiv ist
    if (_searchController.text.isNotEmpty) {
      return _buildSearchResults();
    }

    // Wenn Kategorie-Filter aktiv ist
    if (_selectedCategory != null) {
      return _buildCategoryResults();
    }

    // Wenn nur beliebte Dokumente angezeigt werden sollen
    if (_showPopularOnly) {
      return _buildPopularResults();
    }

    // Standard: Alle Dokumente mit Kategorien
    return _buildAllDocuments();
  }

  Widget _buildSearchResults() {
    final searchResults = ref.watch(documentsSearchProvider);

    return searchResults.when(
      loading: () => const LoadingWidget(),
      error: (error, stack) => AppErrorWidget(
        error: error.toString(),
        onRetry: () {
          ref
              .read(documentsSearchProvider.notifier)
              .search(_searchController.text);
        },
      ),
      data: (documents) {
        if (documents.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search_off, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'Keine Dokumente gefunden',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: documents.length,
          itemBuilder: (context, index) {
            return DocumentCard(document: documents[index]);
          },
        );
      },
    );
  }

  Widget _buildCategoryResults() {
    final categoryDocuments = ref.watch(
      documentsByCategoryProvider(_selectedCategory!),
    );

    return categoryDocuments.when(
      loading: () => const LoadingWidget(),
      error: (error, stack) => AppErrorWidget(
        error: error.toString(),
        onRetry: () {
          ref.invalidate(documentsByCategoryProvider(_selectedCategory!));
        },
      ),
      data: (documents) {
        if (documents.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.folder_open, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'Keine Dokumente in dieser Kategorie',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: documents.length,
          itemBuilder: (context, index) {
            return DocumentCard(document: documents[index]);
          },
        );
      },
    );
  }

  Widget _buildPopularResults() {
    final popularDocuments = ref.watch(popularDocumentsProvider);

    return popularDocuments.when(
      loading: () => const LoadingWidget(),
      error: (error, stack) => AppErrorWidget(
        error: error.toString(),
        onRetry: () {
          ref.invalidate(popularDocumentsProvider);
        },
      ),
      data: (documents) {
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: documents.length,
          itemBuilder: (context, index) {
            return DocumentCard(document: documents[index]);
          },
        );
      },
    );
  }

  Widget _buildAllDocuments() {
    final allDocuments = ref.watch(allDocumentsProvider);

    return allDocuments.when(
      loading: () => const LoadingWidget(),
      error: (error, stack) => AppErrorWidget(
        error: error.toString(),
        onRetry: () {
          ref.invalidate(allDocumentsProvider);
        },
      ),
      data: (documents) {
        // Gruppiere Dokumente nach Kategorien
        final documentsByCategory = <DocumentCategory, List<Document>>{};
        for (final doc in documents) {
          documentsByCategory.putIfAbsent(doc.category, () => []).add(doc);
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: documentsByCategory.length,
          itemBuilder: (context, index) {
            final category = documentsByCategory.keys.elementAt(index);
            final categoryDocs = documentsByCategory[category]!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Kategorie Header
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    children: [
                      Icon(
                        _getCategoryIcon(category),
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _getCategoryDisplayName(category),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${categoryDocs.length} Dokument${categoryDocs.length != 1 ? 'e' : ''}',
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                // Dokumente in dieser Kategorie
                ...categoryDocs.map((doc) => DocumentCard(document: doc)),
                const SizedBox(height: 16),
              ],
            );
          },
        );
      },
    );
  }

  IconData _getCategoryIcon(DocumentCategory category) {
    switch (category) {
      case DocumentCategory.applications:
        return Icons.description;
      case DocumentCategory.permits:
        return Icons.gavel;
      case DocumentCategory.taxes:
        return Icons.receipt_long;
      case DocumentCategory.socialServices:
        return Icons.people;
      case DocumentCategory.civilRegistry:
        return Icons.person;
      case DocumentCategory.planning:
        return Icons.map;
      case DocumentCategory.announcements:
        return Icons.campaign;
      case DocumentCategory.regulations:
        return Icons.gavel;
      case DocumentCategory.emergency:
        return Icons.emergency;
      case DocumentCategory.other:
        return Icons.folder;
    }
  }

  String _getCategoryDisplayName(DocumentCategory category) {
    switch (category) {
      case DocumentCategory.applications:
        return 'Anträge';
      case DocumentCategory.permits:
        return 'Genehmigungen';
      case DocumentCategory.taxes:
        return 'Steuern & Abgaben';
      case DocumentCategory.socialServices:
        return 'Soziale Dienste';
      case DocumentCategory.civilRegistry:
        return 'Bürgeramt';
      case DocumentCategory.planning:
        return 'Stadtplanung';
      case DocumentCategory.announcements:
        return 'Bekanntmachungen';
      case DocumentCategory.regulations:
        return 'Satzungen';
      case DocumentCategory.emergency:
        return 'Notfall';
      case DocumentCategory.other:
        return 'Sonstige';
    }
  }
}
