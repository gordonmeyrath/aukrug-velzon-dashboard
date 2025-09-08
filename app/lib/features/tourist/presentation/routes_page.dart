import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design/widgets/app_card.dart';
import '../data/routes_api_repository.dart';
import '../domain/route_item.dart';

class RoutesPage extends ConsumerStatefulWidget {
  const RoutesPage({super.key});

  @override
  ConsumerState<RoutesPage> createState() => _RoutesPageState();
}

class _RoutesPageState extends ConsumerState<RoutesPage> {
  final TextEditingController _searchController = TextEditingController();
  RouteType? _selectedType;
  RouteDifficulty? _selectedDifficulty;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final routesAsync = ref.watch(routesApiRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Routen & Wege'),
        automaticallyImplyLeading: false, // Da bereits in AppShell
      ),
      body: routesAsync.when(
        data: (routes) {
          final filteredRoutes = _filterRoutes(routes);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Suchfeld
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Routen suchen...',
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

                const SizedBox(height: 20),

                // Typ-Filter
                Text(
                  'Aktivität',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _FilterChip(
                        label: 'Alle',
                        isSelected: _selectedType == null,
                        onTap: () => setState(() => _selectedType = null),
                      ),
                      const SizedBox(width: 8),
                      ...RouteType.values.map(
                        (type) => Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: _FilterChip(
                            label: '${type.icon} ${type.displayName}',
                            isSelected: _selectedType == type,
                            onTap: () => setState(() => _selectedType = type),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Schwierigkeit-Filter
                Text(
                  'Schwierigkeit',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _FilterChip(
                        label: 'Alle',
                        isSelected: _selectedDifficulty == null,
                        onTap: () => setState(() => _selectedDifficulty = null),
                      ),
                      const SizedBox(width: 8),
                      ...RouteDifficulty.values.map(
                        (difficulty) => Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: _DifficultyChip(
                            difficulty: difficulty,
                            isSelected: _selectedDifficulty == difficulty,
                            onTap: () => setState(
                              () => _selectedDifficulty = difficulty,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Routen Liste
                Text(
                  'Verfügbare Routen (${filteredRoutes.length})',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),

                if (filteredRoutes.isEmpty)
                  const AppCard(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Center(child: Text('Keine Routen gefunden')),
                    ),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredRoutes.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (context, index) =>
                        _RouteCard(route: filteredRoutes[index]),
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

  List<RouteItem> _filterRoutes(List<RouteItem> routes) {
    var filtered = routes;

    if (_selectedType != null) {
      filtered = filtered
          .where((route) => route.type == _selectedType)
          .toList();
    }

    if (_selectedDifficulty != null) {
      filtered = filtered
          .where((route) => route.difficulty == _selectedDifficulty)
          .toList();
    }

    if (_searchController.text.isNotEmpty) {
      final query = _searchController.text.toLowerCase();
      filtered = filtered
          .where(
            (route) =>
                route.name.toLowerCase().contains(query) ||
                route.description.toLowerCase().contains(query) ||
                route.highlights.any(
                  (highlight) => highlight.toLowerCase().contains(query),
                ),
          )
          .toList();
    }

    return filtered;
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

class _DifficultyChip extends StatelessWidget {
  final RouteDifficulty difficulty;
  final bool isSelected;
  final VoidCallback onTap;

  const _DifficultyChip({
    required this.difficulty,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color chipColor;
    switch (difficulty.color) {
      case 'green':
        chipColor = Colors.green;
        break;
      case 'orange':
        chipColor = Colors.orange;
        break;
      case 'red':
        chipColor = Colors.red;
        break;
      default:
        chipColor = Theme.of(context).colorScheme.primary;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? chipColor : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: chipColor),
        ),
        child: Text(
          difficulty.displayName,
          style: TextStyle(
            color: isSelected ? Colors.white : chipColor,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class _RouteCard extends StatelessWidget {
  final RouteItem route;

  const _RouteCard({required this.route});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openDetails(context),
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header mit Bild und Typ
            if (route.imageUrls.isNotEmpty)
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(route.imageUrls.first),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 12,
                        left: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${route.type.icon} ${route.type.displayName}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 12,
                        right: 12,
                        child: _DifficultyBadge(difficulty: route.difficulty),
                      ),
                    ],
                  ),
                ),
              ),

            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Titel und Statistiken
                  Text(
                    route.name,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Route Stats
                  Row(
                    children: [
                      _StatChip(
                        icon: Icons.straighten,
                        label: '${route.distance.toStringAsFixed(1)} km',
                      ),
                      const SizedBox(width: 12),
                      _StatChip(
                        icon: Icons.access_time,
                        label: _formatDuration(route.duration),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Beschreibung
                  Text(
                    route.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),

                  // Highlights
                  if (route.highlights.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: route.highlights
                          .take(3)
                          .map(
                            (highlight) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).colorScheme.primaryContainer,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                highlight,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onPrimaryContainer,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ],

                  const SizedBox(height: 16),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.map),
                          label: const Text('Route anzeigen'),
                          onPressed: () => _openDetails(context),
                        ),
                      ),
                      const SizedBox(width: 12),
                      if (route.downloadUrl != null)
                        IconButton(
                          icon: const Icon(Icons.download),
                          onPressed: () => _downloadRoute(context),
                          tooltip: 'GPX herunterladen',
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openDetails(BuildContext context) {
    context.push('/tourist/routes/${route.id}');
  }

  void _downloadRoute(BuildContext context) {
    // TODO: Implement route download
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Download wird vorbereitet...')),
    );
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);

    if (hours > 0) {
      return '${hours}h ${minutes}min';
    } else {
      return '${minutes}min';
    }
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _StatChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: Theme.of(context).colorScheme.onSecondaryContainer,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.onSecondaryContainer,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _DifficultyBadge extends StatelessWidget {
  final RouteDifficulty difficulty;

  const _DifficultyBadge({required this.difficulty});

  @override
  Widget build(BuildContext context) {
    Color badgeColor;
    switch (difficulty.color) {
      case 'green':
        badgeColor = Colors.green;
        break;
      case 'orange':
        badgeColor = Colors.orange;
        break;
      case 'red':
        badgeColor = Colors.red;
        break;
      default:
        badgeColor = Theme.of(context).colorScheme.primary;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        difficulty.displayName,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
