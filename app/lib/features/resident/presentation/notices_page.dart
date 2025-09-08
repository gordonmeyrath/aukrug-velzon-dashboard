import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design/widgets/app_card.dart';
import '../data/notices_api_repository.dart';
import '../domain/notice.dart';

class NoticesPage extends ConsumerStatefulWidget {
  const NoticesPage({super.key});

  @override
  ConsumerState<NoticesPage> createState() => _NoticesPageState();
}

class _NoticesPageState extends ConsumerState<NoticesPage> {
  final TextEditingController _searchController = TextEditingController();
  NoticeCategory? _selectedCategory;
  bool _showOnlyImportant = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final noticesAsync = ref.watch(noticesApiRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mitteilungen'),
        automaticallyImplyLeading: false, // Da bereits in AppShell
      ),
      body: noticesAsync.when(
        data: (allNotices) {
          final filteredNotices = _filterNotices(allNotices);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Suchfeld
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Mitteilungen suchen...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {});
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (value) => setState(() {}),
                ),

                const SizedBox(height: 16),

                // Filter
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 40,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            _FilterChip(
                              label: 'Alle',
                              isSelected: _selectedCategory == null,
                              onTap: () =>
                                  setState(() => _selectedCategory = null),
                            ),
                            const SizedBox(width: 8),
                            ...NoticeCategory.values.map(
                              (category) => Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: _FilterChip(
                                  label:
                                      '${category.icon} ${category.displayName}',
                                  isSelected: _selectedCategory == category,
                                  onTap: () => setState(
                                    () => _selectedCategory = category,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Wichtige Mitteilungen Filter
                Row(
                  children: [
                    Checkbox(
                      value: _showOnlyImportant,
                      onChanged: (value) =>
                          setState(() => _showOnlyImportant = value ?? false),
                    ),
                    const Text('Nur wichtige Mitteilungen'),
                  ],
                ),

                const SizedBox(height: 16),

                // Statistiken
                _buildStatistics(filteredNotices),

                const SizedBox(height: 16),

                // Mitteilungen Liste
                if (filteredNotices.isEmpty)
                  const AppCard(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Center(child: Text('Keine Mitteilungen gefunden')),
                    ),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredNotices.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) =>
                        _NoticeCard(notice: filteredNotices[index]),
                  ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) =>
            Center(child: Text('Fehler beim Laden: $error')),
      ),
    );
  }

  List<Notice> _filterNotices(List<Notice> notices) {
    var filtered = notices;

    if (_selectedCategory != null) {
      filtered = filtered
          .where((notice) => notice.category == _selectedCategory)
          .toList();
    }

    if (_showOnlyImportant) {
      filtered = filtered.where((notice) => notice.isImportant).toList();
    }

    if (_searchController.text.isNotEmpty) {
      final query = _searchController.text.toLowerCase();
      filtered = filtered
          .where(
            (notice) =>
                notice.title.toLowerCase().contains(query) ||
                notice.content.toLowerCase().contains(query),
          )
          .toList();
    }

    return filtered;
  }

  Widget _buildStatistics(List<Notice> filteredNotices) {
    final importantCount = filteredNotices.where((n) => n.isImportant).length;
    final pinnedCount = filteredNotices.where((n) => n.isPinned).length;

    return AppCard(
      child: Row(
        children: [
          Expanded(
            child: _StatisticItem(
              icon: Icons.article,
              label: 'Gesamt',
              value: filteredNotices.length.toString(),
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _StatisticItem(
              icon: Icons.priority_high,
              label: 'Wichtig',
              value: importantCount.toString(),
              color: Colors.orange,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _StatisticItem(
              icon: Icons.push_pin,
              label: 'Angepinnt',
              value: pinnedCount.toString(),
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.outline,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(context).colorScheme.onSurface,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class _StatisticItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatisticItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _NoticeCard extends StatelessWidget {
  final Notice notice;

  const _NoticeCard({required this.notice});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openDetails(context),
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header mit Tags
            Row(
              children: [
                Text(
                  notice.category.icon,
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(width: 8),
                Text(
                  notice.category.displayName,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                if (notice.isPinned)
                  Icon(Icons.push_pin, size: 16, color: Colors.red.shade600),
                if (notice.isImportant) ...[
                  if (notice.isPinned) const SizedBox(width: 4),
                  Icon(
                    Icons.priority_high,
                    size: 16,
                    color: Colors.orange.shade600,
                  ),
                ],
                const SizedBox(width: 8),
                Text(
                  _formatDate(notice.publishedAt),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Titel
            Text(
              notice.title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            // Content Preview
            Text(
              notice.content,
              style: Theme.of(context).textTheme.bodyMedium,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),

            // Footer mit Autor und Abteilung
            if (notice.authorName != null || notice.departmentName != null) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.person,
                    size: 16,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    notice.authorName ?? 'Unbekannt',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  if (notice.departmentName != null) ...[
                    const Text(' • '),
                    Text(
                      notice.departmentName!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ],
              ),
            ],

            // Gültigkeitsdatum
            if (notice.validUntil != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: notice.validUntil!.isBefore(DateTime.now())
                      ? Colors.red.withOpacity(0.1)
                      : Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 14,
                      color: notice.validUntil!.isBefore(DateTime.now())
                          ? Colors.red
                          : Colors.green,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Gültig bis ${_formatDate(notice.validUntil!)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: notice.validUntil!.isBefore(DateTime.now())
                            ? Colors.red
                            : Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // Anhänge
            if (notice.attachmentUrls.isNotEmpty) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.attach_file, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    '${notice.attachmentUrls.length} Anhang(e)',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _openDetails(BuildContext context) {
    context.push('/resident/notices/${notice.id}');
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return 'vor ${difference.inMinutes} Min';
      }
      return 'vor ${difference.inHours} Std';
    } else if (difference.inDays == 1) {
      return 'Gestern';
    } else if (difference.inDays < 7) {
      return 'vor ${difference.inDays} Tagen';
    } else {
      return '${date.day}.${date.month}.${date.year}';
    }
  }
}
