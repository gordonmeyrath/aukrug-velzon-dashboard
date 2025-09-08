import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

import '../../../core/config/app_config.dart';
import '../../../core/connectivity/connectivity_provider.dart';
import '../../map/data/map_view_prefs.dart';
import '../../map/presentation/widgets/aukrug_map.dart';
import '../../map/presentation/widgets/map_marker_factory.dart';
import '../data/reports_repository.dart'; // für DataOrigin
import '../domain/report.dart';
import 'reports_controller.dart';
import 'status_colors.dart';

class ReportsUnifiedPage extends ConsumerStatefulWidget {
  const ReportsUnifiedPage({super.key});

  @override
  ConsumerState<ReportsUnifiedPage> createState() => _ReportsUnifiedPageState();
}

class _ReportsUnifiedPageState extends ConsumerState<ReportsUnifiedPage>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late final TabController _tabController;
  final _searchController = TextEditingController();
  final _searchDebouncer = _Debouncer(const Duration(milliseconds: 450));
  bool _didAutoRefresh = false;
  final ScrollController _listScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _tabController = TabController(length: 2, vsync: this);
    _searchController.addListener(() {
      final text = _searchController.text;
      _searchDebouncer.run(() {
        if (!mounted) return;
        ref.read(reportsControllerProvider.notifier).setQuery(text);
      });
    });
    // Listener für Delta-Updates -> SnackBar bei neuen Meldungen seit letztem Sync
    ref.listen<ReportsState>(reportsControllerProvider, (previous, next) {
      final prev = previous;
      if (prev == null) return;
      final deltaChanged = prev.deltaStats != next.deltaStats;
      if (prev.newSinceSyncCount != next.newSinceSyncCount &&
          next.newSinceSyncCount > 0 &&
          next.dataOrigin != DataOrigin.freshFullSync) {
        // Weiterhin spezielle Snackbar für neue Berichte
        final count = next.newSinceSyncCount;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              count == 1
                  ? '1 neuer Bericht seit letztem vollständigen Sync'
                  : '$count neue Berichte seit letztem vollständigen Sync',
            ),
            action: SnackBarAction(
              label: 'Anzeigen',
              onPressed: () {
                ref
                    .read(reportsControllerProvider.notifier)
                    .toggleShowOnlyNewSinceSync();
              },
            ),
          ),
        );
      } else if (deltaChanged && next.dataOrigin != DataOrigin.freshFullSync) {
        final stats = next.deltaStats;
        if (stats != null && (!stats.isEmpty)) {
          final parts = <String>[];
          if (stats.added > 0) parts.add('${stats.added} neu');
          if (stats.updated > 0) parts.add('${stats.updated} aktualisiert');
          if (stats.deleted > 0) parts.add('${stats.deleted} entfernt');
          if (parts.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Änderungen: ${parts.join(' / ')}')),
            );
          }
        }
      }
    });
    // Initial evtl. Auto-Refresh bei Stale
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeAutoRefresh());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _tabController.dispose();
    _searchController.dispose();
    _searchDebouncer.dispose();
    _listScrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _maybeAutoRefresh();
    }
  }

  void _maybeAutoRefresh() {
    if (!mounted) return;
    final s = ref.read(reportsControllerProvider);
    if (s.isStale && !_didAutoRefresh && !s.loading) {
      _didAutoRefresh = true;
      ref.read(reportsControllerProvider.notifier).refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(reportsControllerProvider);
    final controller = ref.read(reportsControllerProvider.notifier);
    final liveOffline = ref.watch(isOfflineProvider);
    if (liveOffline != state.isOffline) {
      // sanftes Update nur des Offline Flags ohne Re-Filter
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        controller.updateOfflineFlag(liveOffline);
      });
    }

    // Snackbar für neue Fehler anzeigen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final failure = state.failure;
      if (failure != null && mounted) {
        final messenger = ScaffoldMessenger.maybeOf(context);
        if (messenger != null) {
          messenger.showSnackBar(
            SnackBar(
              content: Text(failure.message),
              action: SnackBarAction(
                label: 'Retry',
                onPressed: controller.load,
              ),
            ),
          );
        }
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Builder(
          builder: (context) {
            final s = ref.watch(reportsControllerProvider);
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Mängelmelder'),
                if (s.newSinceSyncCount > 0) ...[
                  const SizedBox(width: 8),
                  _NewBadge(count: s.newSinceSyncCount),
                ],
                if (s.isOffline || s.fromCache) ...[
                  const SizedBox(width: 6),
                  Tooltip(
                    message: () {
                      if (s.isOffline) return 'Offline Modus';
                      switch (s.dataOrigin) {
                        case DataOrigin.cacheOnly:
                          return 'Nur Cache verfügbar';
                        case DataOrigin.cachePrimed:
                          return 'Cache (Hintergrund-Aktualisierung aktiv)';
                        case DataOrigin.freshFullSync:
                        case null:
                          return 'Frische Daten';
                      }
                    }(),
                    child: Icon(
                      s.isOffline
                          ? Icons.wifi_off
                          : (s.dataOrigin == DataOrigin.cacheOnly
                                ? Icons.cloud_off
                                : Icons.cloud_sync),
                      size: 18,
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ],
              ],
            );
          },
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Liste', icon: Icon(Icons.list_alt)),
            Tab(text: 'Karte', icon: Icon(Icons.map_outlined)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.go('/resident/report'),
            tooltip: 'Neue Meldung',
          ),
        ],
      ),
      body: Column(
        children: [
          if (AppConfig.enableSyncDebug) _SyncDebugBar(state: state),
          _FiltersBar(
            searchController: _searchController,
            state: state,
            onCategoryChanged: controller.setCategory,
            onStatusChanged: controller.setStatus,
            onClear: controller.clearFilters,
            onSortChanged: controller.setSort,
            onStaleMinutesChanged: controller.setStaleMinutes,
            onToggleNewSinceSync: controller.toggleShowOnlyNewSinceSync,
          ),
          _LastUpdatedBar(state: state, onRefresh: controller.refresh),
          if (state.isOffline || state.fromCache)
            _OfflineInfoBar(
              isOffline: state.isOffline,
              fromCache: state.fromCache,
              origin: state.dataOrigin,
            ),
          Expanded(
            child: state.loading
                ? const Center(child: CircularProgressIndicator())
                : state.failure != null
                ? _ErrorView(
                    failureMsg: state.failure!.message,
                    retry: controller.load,
                  )
                : RefreshIndicator(
                    onRefresh: controller.refresh,
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _ReportsListView(
                          reports: state.filtered,
                          originalCount: state.all.length,
                          hasActiveFilter:
                              state.query.isNotEmpty ||
                              state.category != null ||
                              state.status != null,
                          sort: state.sort,
                          lastFullSyncAt: state.lastFullSyncAt,
                          addedIds: state.highlightedAddedIds,
                          updatedIds: state.highlightedUpdatedIds,
                          externalScrollController: _listScrollController,
                          onSelect: (r) {
                            controller.selectReport(r);
                            _showReportDetails(context, r);
                          },
                        ),
                        _ReportsMapTab(
                          reports: state.filtered,
                          selected: state.selectedReport,
                          onSelect: (r) {
                            controller.selectReport(r);
                            _showReportDetails(context, r);
                          },
                          onClearSelection: () => controller.selectReport(null),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Consumer(
            builder: (context, ref, _) {
              final s = ref.watch(reportsControllerProvider);
              final hasHighlights =
                  s.highlightedAddedIds.isNotEmpty ||
                  s.highlightedUpdatedIds.isNotEmpty;
              if (!hasHighlights) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: FloatingActionButton.extended(
                  heroTag: 'jump_new',
                  onPressed: () {
                    final firstId = s.highlightedAddedIds.isNotEmpty
                        ? s.highlightedAddedIds.first
                        : s.highlightedUpdatedIds.first;
                    final list = s.filtered;
                    final idx = list.indexWhere((r) => r.id == firstId);
                    if (idx >= 0) {
                      final offset = (idx * 96.0)
                          .clamp(
                            0,
                            _listScrollController.position.maxScrollExtent,
                          )
                          .toDouble();
                      _listScrollController.animateTo(
                        offset,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOutCubic,
                      );
                    }
                  },
                  label: const Text('Zu neuen'),
                  icon: const Icon(Icons.new_releases),
                ),
              );
            },
          ),
          FloatingActionButton(
            heroTag: 'add_new',
            onPressed: () => context.go('/resident/report'),
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}

class _SyncDebugBar extends ConsumerWidget {
  final ReportsState state;
  const _SyncDebugBar({required this.state});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final analytics = ref.read(reportsControllerProvider.notifier).analytics;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withOpacity(0.6),
        border: Border(
          bottom: BorderSide(color: cs.outlineVariant.withOpacity(0.4)),
        ),
      ),
      child: Wrap(
        spacing: 16,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            'Origin: ${state.dataOrigin?.name ?? '—'}',
            style: Theme.of(context).textTheme.labelSmall,
          ),
          Text(
            'FullSync: ${state.lastFullSyncAt?.toIso8601String().split('T').last.substring(0, 8) ?? '–'}',
            style: Theme.of(context).textTheme.labelSmall,
          ),
          Text(
            'Δ added:${state.deltaStats?.added ?? 0} upd:${state.deltaStats?.updated ?? 0} del:${state.deltaStats?.deleted ?? 0}',
            style: Theme.of(context).textTheme.labelSmall,
          ),
          Text(
            'Poll: ${analytics.totalPolls} (${(analytics.deltaEfficiency * 100).toStringAsFixed(0)}% eff)',
            style: Theme.of(context).textTheme.labelSmall,
          ),
          if (state.highlightedAddedIds.isNotEmpty)
            Text(
              '+${state.highlightedAddedIds.length}',
              style: Theme.of(
                context,
              ).textTheme.labelSmall?.copyWith(color: cs.secondary),
            ),
          if (state.highlightedUpdatedIds.isNotEmpty)
            Text(
              '~${state.highlightedUpdatedIds.length}',
              style: Theme.of(
                context,
              ).textTheme.labelSmall?.copyWith(color: cs.tertiary),
            ),
        ],
      ),
    );
  }
}

class _NewBadge extends StatelessWidget {
  final int count;
  const _NewBadge({required this.count});
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final display = count > 99 ? '99+' : count.toString();
    return Semantics(
      label: '$display neue Meldungen seit letztem Sync',
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: scheme.primary,
          borderRadius: BorderRadius.circular(10),
        ),
        constraints: const BoxConstraints(minWidth: 20),
        child: Text(
          display,
          style: TextStyle(
            color: scheme.onPrimary,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class _FiltersBar extends StatelessWidget {
  final TextEditingController searchController;
  final ReportsState state;
  final ValueChanged<ReportCategory?> onCategoryChanged;
  final ValueChanged<ReportStatus?> onStatusChanged;
  final VoidCallback onClear;
  final ValueChanged<ReportsSort> onSortChanged;
  // Neues Callback für Stale-Intervall
  final ValueChanged<int>? onStaleMinutesChanged;
  final VoidCallback? onToggleNewSinceSync;
  const _FiltersBar({
    required this.searchController,
    required this.state,
    required this.onCategoryChanged,
    required this.onStatusChanged,
    required this.onClear,
    required this.onSortChanged,
    this.onStaleMinutesChanged,
    this.onToggleNewSinceSync,
  });
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Suchen',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: state.query.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          searchController.clear();
                        },
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<ReportCategory?>(
                    value: state.category,
                    decoration: const InputDecoration(labelText: 'Kategorie'),
                    items: [
                      const DropdownMenuItem(value: null, child: Text('Alle')),
                      ...ReportCategory.values.map(
                        (c) => DropdownMenuItem(
                          value: c,
                          child: Text(c.displayName),
                        ),
                      ),
                    ],
                    onChanged: onCategoryChanged,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<ReportStatus?>(
                    value: state.status,
                    decoration: const InputDecoration(labelText: 'Status'),
                    items: [
                      const DropdownMenuItem(value: null, child: Text('Alle')),
                      ...ReportStatus.values.map(
                        (s) => DropdownMenuItem(
                          value: s,
                          child: Text(s.displayName),
                        ),
                      ),
                    ],
                    onChanged: onStatusChanged,
                  ),
                ),
                IconButton(
                  tooltip: 'Filter zurücksetzen',
                  onPressed: onClear,
                  icon: const Icon(Icons.refresh),
                ),
                if (onStaleMinutesChanged != null)
                  PopupMenuButton<int>(
                    tooltip: 'Auto-Refresh Intervall',
                    icon: const Icon(Icons.timer_outlined),
                    initialValue: state.staleMinutes,
                    onSelected: onStaleMinutesChanged!,
                    itemBuilder: (context) => [
                      const PopupMenuItem(value: 0, child: Text('Nie')),
                      const PopupMenuItem(value: 1, child: Text('1 Min')),
                      const PopupMenuItem(value: 5, child: Text('5 Min')),
                      const PopupMenuItem(value: 15, child: Text('15 Min')),
                      const PopupMenuItem(value: 30, child: Text('30 Min')),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<ReportsSort>(
                    value: state.sort,
                    decoration: const InputDecoration(labelText: 'Sortierung'),
                    items: [
                      const DropdownMenuItem(
                        value: ReportsSort.latest,
                        child: Text('Neueste zuerst'),
                      ),
                      const DropdownMenuItem(
                        value: ReportsSort.oldest,
                        child: Text('Älteste zuerst'),
                      ),
                      const DropdownMenuItem(
                        value: ReportsSort.priorityHighFirst,
                        child: Text('Priorität (hoch → niedrig)'),
                      ),
                      const DropdownMenuItem(
                        value: ReportsSort.status,
                        child: Text('Status'),
                      ),
                    ],
                    onChanged: (v) {
                      if (v != null) onSortChanged(v);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      FilterChip(
                        label: Text(
                          state.newSinceSyncCount > 0
                              ? 'Neu seit Sync (${state.newSinceSyncCount})'
                              : 'Neu seit Sync',
                        ),
                        selected: state.showOnlyNewSinceSync,
                        onSelected: (_) => onToggleNewSinceSync?.call(),
                      ),
                      if (state.category != null)
                        InputChip(
                          label: Text(state.category!.displayName),
                          onDeleted: () => onCategoryChanged(null),
                        ),
                      if (state.status != null)
                        InputChip(
                          label: Text(state.status!.displayName),
                          onDeleted: () => onStatusChanged(null),
                        ),
                      if (state.query.isNotEmpty)
                        InputChip(
                          label: Text('Suche: "${state.query}"'),
                          onDeleted: () => searchController.clear(),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ReportsListView extends StatelessWidget {
  final List<Report> reports;
  final ValueChanged<Report> onSelect;
  final int originalCount;
  final bool hasActiveFilter;
  final ReportsSort? sort;
  final DateTime? lastFullSyncAt;
  final Set<int>? addedIds;
  final Set<int>? updatedIds;
  final ScrollController? externalScrollController;
  const _ReportsListView({
    required this.reports,
    required this.onSelect,
    required this.originalCount,
    required this.hasActiveFilter,
    this.sort,
    this.lastFullSyncAt,
    this.addedIds,
    this.updatedIds,
    this.externalScrollController,
  });
  @override
  Widget build(BuildContext context) {
    if (reports.isEmpty) {
      final theme = Theme.of(context);
      final txt = theme.textTheme;
      final bool hadData = originalCount > 0;
      String title;
      String desc;
      List<Widget> actions = [];
      if (!hadData) {
        title = 'Noch keine Meldungen';
        desc = 'Erstelle die erste Meldung über den + Button.';
      } else if (hasActiveFilter) {
        title = 'Keine Treffer';
        desc = 'Passe Suche oder Filter an.';
        actions.add(
          FilledButton.tonal(
            onPressed: () => Navigator.of(
              context,
            ).maybePop(), // oder könnte Callback für Clear sein
            child: const Text('Zurück'),
          ),
        );
      } else {
        title = 'Keine Meldungen';
        desc = 'Der Datenbestand ist leer.';
      }
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.inbox_outlined, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              Text(title, style: txt.titleLarge),
              const SizedBox(height: 8),
              Text(desc, style: txt.bodyMedium, textAlign: TextAlign.center),
              if (actions.isNotEmpty) ...[
                const SizedBox(height: 16),
                Wrap(spacing: 12, children: actions),
              ],
            ],
          ),
        ),
      );
    }
    return ListView.builder(
      controller: externalScrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: reports.length,
      itemBuilder: (context, index) {
        final r = reports[index];
        final isNew = (addedIds?.contains(r.id) ?? false);
        final isUpdated = !isNew && (updatedIds?.contains(r.id) ?? false);
        return Semantics(
          label: 'Meldung ${r.title}',
          hint:
              'Status ${r.status.displayName}, Priorität ${r.priority.displayName}',
          button: true,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOutCubic,
            margin: const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              color: isNew
                  ? Theme.of(
                      context,
                    ).colorScheme.secondaryContainer.withOpacity(0.35)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: isNew
                  ? Border.all(
                      color: Theme.of(context).colorScheme.secondary,
                      width: 1.2,
                    )
                  : null,
            ),
            child: ListTile(
              leading: _PriorityAvatar(priority: r.priority),
              title: Text(r.title),
              subtitle: Text(
                r.description,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(r.status.displayName),
                  if (isNew || isUpdated)
                    Padding(
                      padding: const EdgeInsets.only(top: 2.0),
                      child: Text(
                        isNew ? 'Neu' : 'Aktualisiert',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  if (sort == ReportsSort.priorityHighFirst)
                    Text(
                      r.priority.displayName,
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                ],
              ),
              onTap: () => onSelect(r),
            ),
          ),
        );
      },
    );
  }
}

class _LastUpdatedBar extends StatelessWidget {
  final ReportsState state;
  final Future<void> Function() onRefresh;
  const _LastUpdatedBar({required this.state, required this.onRefresh});
  @override
  Widget build(BuildContext context) {
    final last = state.lastLoadedAt;
    if (last == null) return const SizedBox.shrink();
    final diff = DateTime.now().difference(last);
    final isStale = state.isStale;
    final showCache = state.fromCache;
    final text =
        _humanize(diff) +
        (isStale ? ' • veraltet' : '') +
        (showCache ? ' • Cache' : '');
    return Material(
      color: Theme.of(
        context,
      ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: Row(
          children: [
            Icon(
              Icons.history,
              size: 16,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Aktualisiert: $text',
                style: Theme.of(context).textTheme.bodySmall,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            TextButton.icon(
              onPressed: state.loading ? null : () => onRefresh(),
              icon: state.loading
                  ? SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.refresh, size: 16),
              label: const Text('Aktualisieren'),
            ),
          ],
        ),
      ),
    );
  }

  String _humanize(Duration d) {
    if (d.inSeconds < 60) return 'vor ${d.inSeconds}s';
    if (d.inMinutes < 60) return 'vor ${d.inMinutes}m';
    if (d.inHours < 24) return 'vor ${d.inHours}h';
    return 'vor ${d.inDays}d';
  }
}

class _PriorityAvatar extends StatelessWidget {
  final ReportPriority priority;
  const _PriorityAvatar({required this.priority});
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = colorForReportPriority(scheme, priority);
    final letter = priority.displayName.characters.first.toUpperCase();
    return CircleAvatar(
      backgroundColor: color,
      foregroundColor: _onColor(color, scheme),
      child: Text(letter, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}

class _OfflineInfoBar extends StatelessWidget {
  final bool isOffline;
  final bool fromCache;
  final DataOrigin? origin;
  const _OfflineInfoBar({
    required this.isOffline,
    required this.fromCache,
    required this.origin,
  });
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    String text = '';
    IconData icon = Icons.info_outline;
    if (isOffline) {
      text = 'Offline – Cache';
      icon = Icons.wifi_off;
    } else if (fromCache) {
      switch (origin) {
        case DataOrigin.cacheOnly:
          text = 'Nur Cache verfügbar';
          icon = Icons.cloud_off_outlined;
          break;
        case DataOrigin.cachePrimed:
          text = 'Cache (aktualisiere im Hintergrund)';
          icon = Icons.cloud_sync;
          break;
        case DataOrigin.freshFullSync:
          return const SizedBox.shrink();
        case null:
          text = 'Cache';
          icon = Icons.cloud_off_outlined;
      }
    } else {
      return const SizedBox.shrink();
    }
    return Material(
      color: scheme.surfaceContainerHigh,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: Row(
          children: [
            Icon(icon, size: 16, color: scheme.error),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                text,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: scheme.error),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Color _onColor(Color bg, ColorScheme scheme) {
  // Simple heuristic: choose contrasting color
  final brightness = bg.computeLuminance();
  return brightness > 0.5 ? Colors.black : Colors.white;
}

class _ReportsMapTab extends ConsumerStatefulWidget {
  final List<Report> reports;
  final Report? selected;
  final ValueChanged<Report> onSelect;
  final VoidCallback onClearSelection;
  const _ReportsMapTab({
    required this.reports,
    required this.selected,
    required this.onSelect,
    required this.onClearSelection,
  });
  @override
  ConsumerState<_ReportsMapTab> createState() => _ReportsMapTabState();
}

class _ReportsMapTabState extends ConsumerState<_ReportsMapTab> {
  bool _showLegend = true;
  double _currentZoom = 13.0;
  MapController? _mapController; // über AukrugMap onMapReady befüllt
  @override
  Widget build(BuildContext context) {
    final mapPrefsAsync = ref.watch(mapViewPrefsProvider);
    final prefs = mapPrefsAsync.maybeWhen(data: (p) => p, orElse: () => null);
    final markers = _buildMarkers(widget.reports, prefs);
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: AukrugMap(
            center: prefs?.center,
            zoom: prefs?.zoom ?? 13.0,
            markers: markers,
            showUserLocation: true,
            onMapTap: (_) => widget.onClearSelection(),
            onViewportChanged: (c, z) async {
              final service = await ref.read(
                mapViewPrefsServiceProvider.future,
              );
              final current = (await ref.read(mapViewPrefsProvider.future));
              await service.save(
                current.copyWith(
                  centerLat: c.latitude,
                  centerLng: c.longitude,
                  zoom: z,
                ),
              );
              if (z != _currentZoom) {
                setState(() => _currentZoom = z);
              }
            },
            onMapReady: (ctrl) => _mapController = ctrl,
          ),
        ),
        // Jump-to-new Button
        Positioned(
          bottom: 90,
          right: 12,
          child: Consumer(
            builder: (context, ref, _) {
              final s = ref.watch(reportsControllerProvider);
              final hasHighlights =
                  s.highlightedAddedIds.isNotEmpty ||
                  s.highlightedUpdatedIds.isNotEmpty;
              if (!hasHighlights) return const SizedBox.shrink();
              return FloatingActionButton.small(
                heroTag: 'map_jump_new',
                tooltip: 'Zu neuen Meldungen zentrieren',
                onPressed: () {
                  final firstId = s.highlightedAddedIds.isNotEmpty
                      ? s.highlightedAddedIds.first
                      : s.highlightedUpdatedIds.first;
                  final target = widget.reports.firstWhere(
                    (r) => r.id == firstId,
                    orElse: () => widget.reports.first,
                  );
                  _mapController?.move(
                    LatLng(target.location.latitude, target.location.longitude),
                    (_currentZoom < 15 ? 15 : _currentZoom),
                  );
                  widget.onSelect(target);
                },
                child: const Icon(Icons.my_location),
              );
            },
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Material(
                color: Theme.of(
                  context,
                ).colorScheme.surface.withValues(alpha: 0.9),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => setState(() => _showLegend = !_showLegend),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      _showLegend ? Icons.visibility_off : Icons.visibility,
                      size: 20,
                    ),
                  ),
                ),
              ),
              if (_showLegend) const SizedBox(height: 8),
              if (_showLegend) _StatusLegend(statuses: ReportStatus.values),
            ],
          ),
        ),
        if (widget.selected != null)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _MiniReportCard(
              report: widget.selected!,
              onClose: widget.onClearSelection,
              onDetails: () => _showBottomSheet(context, widget.selected!),
            ),
          ),
      ],
    );
  }

  void _showBottomSheet(BuildContext context, Report report) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.95,
        minChildSize: 0.4,
        builder: (context, scrollController) => _ReportDetailsSheet(
          report: report,
          scrollController: scrollController,
        ),
      ),
    );
  }

  List<Marker> _buildMarkers(List<Report> reports, MapViewPrefs? prefs) {
    // Cluster nur wenn genügend Meldungen und Zoom relativ weit draußen
    const clusterThreshold = 30;
    if (reports.length < clusterThreshold || _currentZoom >= 15) {
      return reports
          .map(
            (r) => MapMarkerFactory.createReportMarker(
              r,
              isSelected: widget.selected?.id == r.id,
              onTap: () => widget.onSelect(r),
              lastFullSyncAt: ref
                  .read(reportsControllerProvider)
                  .lastFullSyncAt,
            ),
          )
          .toList();
    }
    final cellSize = _cellSizeForZoom(_currentZoom); // in Grad
    final Map<_GridKey, List<Report>> buckets = {};
    for (final r in reports) {
      final key = _GridKey(
        (r.location.latitude / cellSize).floor(),
        (r.location.longitude / cellSize).floor(),
      );
      buckets.putIfAbsent(key, () => []).add(r);
    }
    final List<Marker> markers = [];
    buckets.forEach((key, list) {
      if (list.length == 1) {
        final r = list.first;
        markers.add(
          MapMarkerFactory.createReportMarker(
            r,
            isSelected: widget.selected?.id == r.id,
            onTap: () => widget.onSelect(r),
            lastFullSyncAt: ref.read(reportsControllerProvider).lastFullSyncAt,
          ),
        );
      } else {
        final avgLat =
            list.map((e) => e.location.latitude).reduce((a, b) => a + b) /
            list.length;
        final avgLng =
            list.map((e) => e.location.longitude).reduce((a, b) => a + b) /
            list.length;
        markers.add(
          Marker(
            point: LatLng(avgLat, avgLng),
            width: 48,
            height: 48,
            alignment: Alignment.center,
            child: _ClusterMarker(
              count: list.length,
              onTap: () {
                final targetZoom = (_currentZoom + 1).clamp(0, 18);
                _mapController?.move(
                  LatLng(avgLat, avgLng),
                  targetZoom.toDouble(),
                );
              },
            ),
          ),
        );
      }
    });
    return markers;
  }

  double _cellSizeForZoom(double zoom) {
    if (zoom < 11) return 0.04;
    if (zoom < 12) return 0.03;
    if (zoom < 13) return 0.02;
    if (zoom < 14) return 0.01;
    return 0.006; // bei 14 <= z < 15
  }
}

class _GridKey {
  final int x;
  final int y;
  const _GridKey(this.x, this.y);
  @override
  bool operator ==(Object other) =>
      other is _GridKey && other.x == x && other.y == y;
  @override
  int get hashCode => Object.hash(x, y);
}

class _ClusterMarker extends StatelessWidget {
  final int count;
  final VoidCallback onTap;
  const _ClusterMarker({required this.count, required this.onTap});
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bg = _backgroundForCount(scheme, count);
    return Semantics(
      label: 'Cluster mit $count Meldungen',
      button: true,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(colors: [bg, bg.withValues(alpha: 0.6)]),
            border: Border.all(color: scheme.onPrimaryContainer, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            count.toString(),
            style: TextStyle(
              color: scheme.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Color _backgroundForCount(ColorScheme s, int c) {
    if (c < 10) return s.primary;
    if (c < 25) return s.secondary;
    if (c < 50) return s.tertiary;
    return s.error;
  }
}

class _MiniReportCard extends StatelessWidget {
  final Report report;
  final VoidCallback onClose;
  final VoidCallback onDetails;
  const _MiniReportCard({
    required this.report,
    required this.onClose,
    required this.onDetails,
  });
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    report.title,
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    report.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              report.status.displayName,
              style: TextStyle(
                color: scheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            IconButton(
              onPressed: onDetails,
              icon: const Icon(Icons.open_in_full),
            ),
            IconButton(onPressed: onClose, icon: const Icon(Icons.close)),
          ],
        ),
      ),
    );
  }
}

void _showReportDetails(BuildContext context, Report report) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) => DraggableScrollableSheet(
      initialChildSize: 0.6,
      maxChildSize: 0.95,
      minChildSize: 0.4,
      builder: (context, scrollController) => _ReportDetailsSheet(
        report: report,
        scrollController: scrollController,
      ),
    ),
  );
}

class _ReportDetailsSheet extends ConsumerWidget {
  final Report report;
  final ScrollController scrollController;
  const _ReportDetailsSheet({
    required this.report,
    required this.scrollController,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prev = ref
        .read(reportsControllerProvider.notifier)
        .previousVersionOf(report.id);
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 8),
            height: 4,
            width: 40,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.outline,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Expanded(
            child: ListView(
              controller: scrollController,
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  report.title,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(report.description),
                if (prev != null) ...[
                  const SizedBox(height: 16),
                  _DiffSection(current: report, previous: prev),
                ],
                const SizedBox(height: 16),
                Text('Kategorie: ${report.category.displayName}'),
                Text('Status: ${report.status.displayName}'),
                if (report.location.address != null)
                  Text('Adresse: ${report.location.address}'),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                  label: const Text('Schließen'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DiffSection extends StatelessWidget {
  final Report current;
  final Report previous;
  const _DiffSection({required this.current, required this.previous});
  @override
  Widget build(BuildContext context) {
    final changes = <_FieldDiff>[];
    void add(String label, String? before, String? after) {
      if (before == after) return;
      changes.add(_FieldDiff(label: label, before: before, after: after));
    }

    add('Titel', previous.title, current.title);
    add('Beschreibung', previous.description, current.description);
    add('Status', previous.status.displayName, current.status.displayName);
    add(
      'Priorität',
      previous.priority.displayName,
      current.priority.displayName,
    );
    add(
      'Kategorie',
      previous.category.displayName,
      current.category.displayName,
    );
    add('Adresse', previous.location.address, current.location.address);
    add('Antwort', previous.municipalityResponse, current.municipalityResponse);
    if (changes.isEmpty) return const SizedBox.shrink();
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceContainerHigh,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Änderungen', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            ...changes.map((c) => _DiffRow(diff: c)),
          ],
        ),
      ),
    );
  }
}

class _FieldDiff {
  final String label;
  final String? before;
  final String? after;
  _FieldDiff({required this.label, this.before, this.after});
}

class _DiffRow extends StatelessWidget {
  final _FieldDiff diff;
  const _DiffRow({required this.diff});
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(diff.label, style: Theme.of(context).textTheme.labelSmall),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border(left: BorderSide(color: scheme.error, width: 3)),
              color: scheme.errorContainer.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(4),
            ),
            padding: const EdgeInsets.all(6),
            child: Text(
              diff.before ?? '—',
              style: TextStyle(
                decoration: TextDecoration.lineThrough,
                color: scheme.error,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(color: scheme.secondary, width: 3),
              ),
              color: scheme.secondaryContainer.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(4),
            ),
            padding: const EdgeInsets.all(6),
            child: Text(diff.after ?? '—'),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String failureMsg;
  final VoidCallback retry;
  const _ErrorView({required this.failureMsg, required this.retry});
  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.error_outline, size: 48, color: Colors.red),
        const SizedBox(height: 12),
        Text(failureMsg, textAlign: TextAlign.center),
        const SizedBox(height: 12),
        FilledButton(onPressed: retry, child: const Text('Erneut versuchen')),
      ],
    ),
  );
}

/// Kleine Legende für Status-Farben
class _StatusLegend extends StatelessWidget {
  final List<ReportStatus> statuses;
  const _StatusLegend({required this.statuses});
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.surface.withValues(alpha: 0.9),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Status',
              style: Theme.of(
                context,
              ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            ...statuses.map(
              (s) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _StatusDot(status: s),
                    const SizedBox(width: 6),
                    Text(
                      s.displayName,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusDot extends StatelessWidget {
  final ReportStatus status;
  const _StatusDot({required this.status});
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = colorForReportStatus(scheme, status);
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 1.5),
      ),
    );
  }
}

/// Simpler Debouncer
class _Debouncer {
  final Duration delay;
  _Debouncer(this.delay);
  Timer? _timer;
  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }

  void dispose() => _timer?.cancel();
}
