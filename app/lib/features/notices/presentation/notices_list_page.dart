import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../localization/app_localizations.dart';

// Temporary mock data structure until we generate the domain models
class TempNotice {
  final int id;
  final String title;
  final String content;
  final DateTime publishedDate;
  final String priority;
  final String category;
  final List<String> tags;

  TempNotice({
    required this.id,
    required this.title,
    required this.content,
    required this.publishedDate,
    required this.priority,
    required this.category,
    required this.tags,
  });
}

// Temporary provider for notices
final noticesProvider = FutureProvider<List<TempNotice>>((ref) async {
  // Mock data
  final now = DateTime.now();
  return [
    TempNotice(
      id: 1,
      title: 'Straßensperrung Hauptstraße',
      content: 'Die Hauptstraße wird vom 15.-17. September für Bauarbeiten gesperrt. Bitte nutzen Sie die Umleitung über die Dorfstraße.',
      publishedDate: now.subtract(const Duration(days: 2)),
      priority: 'high',
      category: 'Verkehr',
      tags: ['verkehr', 'sperrung', 'umleitung'],
    ),
    TempNotice(
      id: 2,
      title: 'Gemeinderatssitzung September',
      content: 'Die nächste öffentliche Gemeinderatssitzung findet am 20. September um 19:00 Uhr im Rathaus statt.',
      publishedDate: now.subtract(const Duration(days: 5)),
      priority: 'normal',
      category: 'Verwaltung',
      tags: ['gemeinderat', 'sitzung', 'öffentlich'],
    ),
    TempNotice(
      id: 3,
      title: 'Unwetter-Warnung',
      content: 'Der Deutsche Wetterdienst warnt vor schweren Gewittern für heute Abend. Bringen Sie lose Gegenstände in Sicherheit.',
      publishedDate: now.subtract(const Duration(hours: 2)),
      priority: 'urgent',
      category: 'Wetter',
      tags: ['unwetter', 'warnung', 'gewitter'],
    ),
  ];
});

class NoticesListPage extends ConsumerWidget {
  const NoticesListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final noticesAsync = ref.watch(noticesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.notices),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // Filter by category
              // TODO: Implement filter
            },
          ),
        ],
      ),
      body: noticesAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              Text(
                'Error loading notices',
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.refresh(noticesProvider),
                child: Text(l10n.retry),
              ),
            ],
          ),
        ),
        data: (notices) {
          if (notices.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.notifications_outlined,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No notices available',
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: notices.length,
            itemBuilder: (context, index) {
              final notice = notices[index];
              return NoticeListTile(notice: notice);
            },
          );
        },
      ),
    );
  }
}

class NoticeListTile extends StatelessWidget {
  const NoticeListTile({
    super.key,
    required this.notice,
  });

  final TempNotice notice;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd.MM.yyyy HH:mm');

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 12,
          height: 60,
          decoration: BoxDecoration(
            color: _getPriorityColor(notice.priority),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    notice.title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Chip(
                  label: Text(
                    notice.category,
                    style: const TextStyle(fontSize: 12),
                  ),
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.schedule,
                  size: 16,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 4),
                Text(
                  dateFormat.format(notice.publishedDate),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(width: 16),
                Icon(
                  _getPriorityIcon(notice.priority),
                  size: 16,
                  color: _getPriorityColor(notice.priority),
                ),
                const SizedBox(width: 4),
                Text(
                  _getPriorityLabel(notice.priority),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: _getPriorityColor(notice.priority),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Text(
            notice.content,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          // Navigate to notice detail
          // TODO: Implement notice detail navigation
        },
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'urgent':
        return const Color(0xFFF44336); // Red
      case 'high':
        return const Color(0xFFFF9800); // Orange
      case 'normal':
        return const Color(0xFF2196F3); // Blue
      case 'low':
        return const Color(0xFF4CAF50); // Green
      default:
        return const Color(0xFF9E9E9E); // Grey
    }
  }

  IconData _getPriorityIcon(String priority) {
    switch (priority) {
      case 'urgent':
        return Icons.warning;
      case 'high':
        return Icons.priority_high;
      case 'normal':
        return Icons.info;
      case 'low':
        return Icons.info_outline;
      default:
        return Icons.notifications;
    }
  }

  String _getPriorityLabel(String priority) {
    switch (priority) {
      case 'urgent':
        return 'Dringend';
      case 'high':
        return 'Hoch';
      case 'normal':
        return 'Normal';
      case 'low':
        return 'Niedrig';
      default:
        return 'Unbekannt';
    }
  }
}
