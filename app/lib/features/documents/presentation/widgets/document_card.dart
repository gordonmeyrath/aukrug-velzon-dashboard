import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../domain/document.dart';

class DocumentCard extends StatelessWidget {
  final Document document;

  const DocumentCard({super.key, required this.document});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _downloadDocument(context),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header mit Titel und Kategorien-Badge
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          document.title,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        if (document.description.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            document.description,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: Colors.grey[600]),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Kategorie Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getCategoryColor(
                        document.category,
                      ).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: _getCategoryColor(
                          document.category,
                        ).withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      _getCategoryDisplayName(document.category),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: _getCategoryColor(document.category),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // File Info und Tags
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  // Dateityp Icon
                  Chip(
                    avatar: Icon(
                      _getFileTypeIcon(document.fileType ?? 'pdf'),
                      size: 16,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    label: Text(
                      (document.fileType ?? 'PDF').toUpperCase(),
                      style: const TextStyle(fontSize: 12),
                    ),
                    visualDensity: VisualDensity.compact,
                  ),
                  // Dateigröße
                  Chip(
                    avatar: const Icon(Icons.storage, size: 16),
                    label: Text(
                      _formatFileSize(document.fileSizeBytes),
                      style: const TextStyle(fontSize: 12),
                    ),
                    visualDensity: VisualDensity.compact,
                  ),
                  // Beliebtes Dokument Badge
                  if (document.isPopular)
                    Chip(
                      avatar: const Icon(Icons.star, size: 16),
                      label: const Text(
                        'Beliebt',
                        style: TextStyle(fontSize: 12),
                      ),
                      backgroundColor: Colors.amber.withOpacity(0.1),
                      side: BorderSide(color: Colors.amber.withOpacity(0.3)),
                      visualDensity: VisualDensity.compact,
                    ),
                  // Authentifizierung erforderlich Badge
                  if (document.requiresAuthentication)
                    Chip(
                      avatar: const Icon(Icons.lock, size: 16),
                      label: const Text(
                        'Anmeldung erforderlich',
                        style: TextStyle(fontSize: 12),
                      ),
                      backgroundColor: Colors.orange.withOpacity(0.1),
                      side: BorderSide(color: Colors.orange.withOpacity(0.3)),
                      visualDensity: VisualDensity.compact,
                    ),
                ],
              ),

              // Tags
              if (document.tags?.isNotEmpty == true) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 4,
                  children: (document.tags ?? [])
                      .take(3)
                      .map(
                        (tag) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '#$tag',
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(color: Colors.grey[600]),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],

              const SizedBox(height: 12),

              // Footer mit Datum und Download Button
              Row(
                children: [
                  Icon(Icons.update, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    'Aktualisiert: ${_formatDate(document.lastUpdated ?? DateTime.now())}',
                    style: Theme.of(
                      context,
                    ).textTheme.labelSmall?.copyWith(color: Colors.grey[600]),
                  ),
                  const Spacer(),
                  FilledButton.icon(
                    onPressed: () => _downloadDocument(context),
                    icon: const Icon(Icons.download, size: 16),
                    label: const Text('Download'),
                    style: FilledButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getCategoryColor(DocumentCategory category) {
    switch (category) {
      case DocumentCategory.applications:
        return Colors.blue;
      case DocumentCategory.permits:
        return Colors.purple;
      case DocumentCategory.taxes:
        return Colors.green;
      case DocumentCategory.socialServices:
        return Colors.orange;
      case DocumentCategory.civilRegistry:
        return Colors.teal;
      case DocumentCategory.planning:
        return Colors.indigo;
      case DocumentCategory.announcements:
        return Colors.red;
      case DocumentCategory.regulations:
        return Colors.brown;
      case DocumentCategory.emergency:
        return Colors.red[700]!;
      case DocumentCategory.other:
        return Colors.grey;
    }
  }

  String _getCategoryDisplayName(DocumentCategory category) {
    switch (category) {
      case DocumentCategory.applications:
        return 'Anträge';
      case DocumentCategory.permits:
        return 'Genehmigungen';
      case DocumentCategory.taxes:
        return 'Steuern';
      case DocumentCategory.socialServices:
        return 'Soziales';
      case DocumentCategory.civilRegistry:
        return 'Bürgeramt';
      case DocumentCategory.planning:
        return 'Planung';
      case DocumentCategory.announcements:
        return 'Bekanntmachung';
      case DocumentCategory.regulations:
        return 'Satzungen';
      case DocumentCategory.emergency:
        return 'Notfall';
      case DocumentCategory.other:
        return 'Sonstige';
    }
  }

  IconData _getFileTypeIcon(String fileType) {
    switch (fileType.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'xls':
      case 'xlsx':
        return Icons.table_chart;
      case 'jpg':
      case 'jpeg':
      case 'png':
        return Icons.image;
      default:
        return Icons.insert_drive_file;
    }
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  String _formatDate(DateTime date) {
    return '${date.day}.${date.month}.${date.year}';
  }

  Future<void> _downloadDocument(BuildContext context) async {
    try {
      // In einer echten App würde hier der Download stattfinden
      // Für das Demo zeigen wir eine Snackbar
      if (document.requiresAuthentication) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Für dieses Dokument ist eine Anmeldung erforderlich',
            ),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      // Simuliere Download
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Download gestartet: ${document.fileName}'),
          action: SnackBarAction(
            label: 'Details',
            onPressed: () {
              // Hier könnte eine Detailseite geöffnet werden
            },
          ),
        ),
      );

      // Haptic Feedback
      HapticFeedback.lightImpact();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Fehler beim Download: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
