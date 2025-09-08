import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/data/auth_service.dart';
import '../models/marketplace_models.dart';
import '../providers/marketplace_providers.dart';
import '../widgets/marketplace_listing_card.dart';

class MarketplaceMyListingsScreen extends ConsumerStatefulWidget {
  const MarketplaceMyListingsScreen({super.key});

  @override
  ConsumerState<MarketplaceMyListingsScreen> createState() =>
      _MarketplaceMyListingsScreenState();
}

class _MarketplaceMyListingsScreenState
    extends ConsumerState<MarketplaceMyListingsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUserAsync = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meine Anzeigen'),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Aktiv'),
            Tab(text: 'Entwürfe'),
            Tab(text: 'Archiviert'),
            Tab(text: 'Statistiken'),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => _refreshListings(),
            icon: const Icon(Icons.refresh),
            tooltip: 'Aktualisieren',
          ),
        ],
      ),
      body: currentUserAsync.when(
        data: (user) {
          if (user == null) {
            return _buildLoginRequired(context);
          }

          return TabBarView(
            controller: _tabController,
            children: [
              _buildActiveListings(context),
              _buildDraftListings(context),
              _buildArchivedListings(context),
              _buildStatistics(context),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => _buildError(context, error),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _createNewListing(context),
        icon: const Icon(Icons.add),
        label: const Text('Neue Anzeige'),
      ),
    );
  }

  Widget _buildLoginRequired(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.login, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Anmeldung erforderlich',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Sie müssen angemeldet sein, um Ihre Anzeigen zu verwalten.',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/auth/login');
              },
              child: const Text('Anmelden'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError(BuildContext context, Object error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
            const SizedBox(height: 16),
            Text(
              'Fehler beim Laden',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                ref.refresh(currentUserProvider);
                _refreshListings();
              },
              child: const Text('Erneut versuchen'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveListings(BuildContext context) {
    final myListingsAsync = ref.watch(myMarketplaceListingsProvider('active'));

    return myListingsAsync.when(
      data: (listings) => _buildListingsGrid(
        context,
        listings,
        emptyMessage: 'Keine aktiven Anzeigen',
        emptyDescription:
            'Erstellen Sie Ihre erste Anzeige über den Button unten.',
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => _buildListError(context, error),
    );
  }

  Widget _buildDraftListings(BuildContext context) {
    final myListingsAsync = ref.watch(myMarketplaceListingsProvider('draft'));

    return myListingsAsync.when(
      data: (listings) => _buildListingsGrid(
        context,
        listings,
        emptyMessage: 'Keine Entwürfe',
        emptyDescription:
            'Gespeicherte aber noch nicht veröffentlichte Anzeigen erscheinen hier.',
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => _buildListError(context, error),
    );
  }

  Widget _buildArchivedListings(BuildContext context) {
    final myListingsAsync = ref.watch(
      myMarketplaceListingsProvider('archived'),
    );

    return myListingsAsync.when(
      data: (listings) => _buildListingsGrid(
        context,
        listings,
        emptyMessage: 'Keine archivierten Anzeigen',
        emptyDescription:
            'Archivierte oder abgelaufene Anzeigen erscheinen hier.',
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => _buildListError(context, error),
    );
  }

  Widget _buildListingsGrid(
    BuildContext context,
    List<MarketplaceListing> listings, {
    required String emptyMessage,
    required String emptyDescription,
  }) {
    if (listings.isEmpty) {
      return _buildEmptyState(context, emptyMessage, emptyDescription);
    }

    return RefreshIndicator(
      onRefresh: _refreshListings,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: listings.length,
        itemBuilder: (context, index) {
          final listing = listings[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildMyListingCard(context, listing),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
    String message,
    String description,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              message,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => _createNewListing(context),
              icon: const Icon(Icons.add),
              label: const Text('Erste Anzeige erstellen'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMyListingCard(BuildContext context, MarketplaceListing listing) {
    return Card(
      child: Column(
        children: [
          MarketplaceListingCard(
            listing: listing,
            onTap: () => _viewListing(context, listing),
          ),

          // Management buttons
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                _buildStatusChip(listing.status),
                const Spacer(),

                // Action buttons
                IconButton(
                  onPressed: () => _editListing(context, listing),
                  icon: const Icon(Icons.edit, size: 20),
                  tooltip: 'Bearbeiten',
                ),

                IconButton(
                  onPressed: () => _toggleListingStatus(listing),
                  icon: Icon(
                    listing.status == 'active'
                        ? Icons.pause_circle_outline
                        : Icons.play_circle_outline,
                    size: 20,
                  ),
                  tooltip: listing.status == 'active'
                      ? 'Pausieren'
                      : 'Aktivieren',
                ),

                IconButton(
                  onPressed: () => _showListingActions(context, listing),
                  icon: const Icon(Icons.more_vert, size: 20),
                  tooltip: 'Weitere Optionen',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color backgroundColor;
    Color textColor;
    String label;
    IconData icon;

    switch (status.toLowerCase()) {
      case 'active':
        backgroundColor = Colors.green.withOpacity(0.1);
        textColor = Colors.green[700]!;
        label = 'Aktiv';
        icon = Icons.check_circle_outline;
        break;
      case 'draft':
        backgroundColor = Colors.orange.withOpacity(0.1);
        textColor = Colors.orange[700]!;
        label = 'Entwurf';
        icon = Icons.drafts_outlined;
        break;
      case 'paused':
        backgroundColor = Colors.grey.withOpacity(0.1);
        textColor = Colors.grey[700]!;
        label = 'Pausiert';
        icon = Icons.pause_circle_outline;
        break;
      case 'archived':
        backgroundColor = Colors.blue.withOpacity(0.1);
        textColor = Colors.blue[700]!;
        label = 'Archiviert';
        icon = Icons.archive_outlined;
        break;
      case 'expired':
        backgroundColor = Colors.red.withOpacity(0.1);
        textColor = Colors.red[700]!;
        label = 'Abgelaufen';
        icon = Icons.schedule_outlined;
        break;
      default:
        backgroundColor = Colors.grey.withOpacity(0.1);
        textColor = Colors.grey[700]!;
        label = status;
        icon = Icons.info_outline;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: textColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatistics(BuildContext context) {
    final statisticsAsync = ref.watch(myListingStatisticsProvider);

    return statisticsAsync.when(
      data: (stats) => _buildStatisticsContent(context, stats),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => _buildListError(context, error),
    );
  }

  Widget _buildStatisticsContent(
    BuildContext context,
    Map<String, dynamic> stats,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Übersicht', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 16),

          // Statistics cards
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              _buildStatCard(
                context,
                'Aktive Anzeigen',
                '${stats['activeListings'] ?? 0}',
                Icons.storefront,
                Colors.green,
              ),
              _buildStatCard(
                context,
                'Gesamt Aufrufe',
                '${stats['totalViews'] ?? 0}',
                Icons.visibility,
                Colors.blue,
              ),
              _buildStatCard(
                context,
                'Favoriten',
                '${stats['totalFavorites'] ?? 0}',
                Icons.favorite,
                Colors.red,
              ),
              _buildStatCard(
                context,
                'Kontaktanfragen',
                '${stats['totalContacts'] ?? 0}',
                Icons.message,
                Colors.orange,
              ),
            ],
          ),

          const SizedBox(height: 32),

          Text(
            'Aktivität (letzte 30 Tage)',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),

          // Activity chart placeholder
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bar_chart, size: 48, color: Colors.grey),
                  SizedBox(height: 8),
                  Text(
                    'Aktivitätsdiagramm',
                    style: TextStyle(color: Colors.grey),
                  ),
                  Text(
                    'Wird in einer zukünftigen Version verfügbar sein',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListError(BuildContext context, Object error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.red[400]),
            const SizedBox(height: 16),
            Text(
              'Fehler beim Laden der Anzeigen',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _refreshListings,
              child: const Text('Erneut versuchen'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _refreshListings() async {
    // Refresh all listing providers
    ref.invalidate(myMarketplaceListingsProvider('active'));
    ref.invalidate(myMarketplaceListingsProvider('draft'));
    ref.invalidate(myMarketplaceListingsProvider('archived'));
    ref.invalidate(myListingStatisticsProvider);
  }

  void _createNewListing(BuildContext context) {
    Navigator.of(context).pushNamed('/marketplace/create');
  }

  void _viewListing(BuildContext context, MarketplaceListing listing) {
    Navigator.of(
      context,
    ).pushNamed('/marketplace/detail', arguments: listing.id);
  }

  void _editListing(BuildContext context, MarketplaceListing listing) {
    Navigator.of(context).pushNamed('/marketplace/edit', arguments: listing.id);
  }

  Future<void> _toggleListingStatus(MarketplaceListing listing) async {
    try {
      final newStatus = listing.status == 'active' ? 'paused' : 'active';

      await ref
          .read(marketplaceRepositoryProvider)
          .updateListingStatus(listing.id, newStatus);

      _refreshListings();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              newStatus == 'active'
                  ? 'Anzeige wurde aktiviert'
                  : 'Anzeige wurde pausiert',
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fehler: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  void _showListingActions(BuildContext context, MarketplaceListing listing) {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) => _buildActionBottomSheet(context, listing),
    );
  }

  Widget _buildActionBottomSheet(
    BuildContext context,
    MarketplaceListing listing,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            listing.title,
            style: Theme.of(context).textTheme.titleMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 16),

          ListTile(
            leading: const Icon(Icons.share),
            title: const Text('Teilen'),
            onTap: () {
              Navigator.of(context).pop();
              _shareListing(listing);
            },
          ),

          ListTile(
            leading: const Icon(Icons.copy),
            title: const Text('Duplizieren'),
            onTap: () {
              Navigator.of(context).pop();
              _duplicateListing(listing);
            },
          ),

          if (listing.status == 'active')
            ListTile(
              leading: const Icon(Icons.archive),
              title: const Text('Archivieren'),
              onTap: () {
                Navigator.of(context).pop();
                _archiveListing(listing);
              },
            ),

          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: const Text('Löschen', style: TextStyle(color: Colors.red)),
            onTap: () {
              Navigator.of(context).pop();
              _confirmDeleteListing(context, listing);
            },
          ),

          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Abbrechen'),
            ),
          ),
        ],
      ),
    );
  }

  void _shareListing(MarketplaceListing listing) {
    // Implement sharing functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Sharing-Funktion folgt in einer späteren Version'),
      ),
    );
  }

  Future<void> _duplicateListing(MarketplaceListing listing) async {
    try {
      await ref
          .read(marketplaceRepositoryProvider)
          .duplicateListing(listing.id);
      _refreshListings();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Anzeige wurde dupliziert')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fehler beim Duplizieren: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _archiveListing(MarketplaceListing listing) async {
    try {
      await ref
          .read(marketplaceRepositoryProvider)
          .updateListingStatus(listing.id, 'archived');

      _refreshListings();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Anzeige wurde archiviert')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fehler beim Archivieren: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _confirmDeleteListing(BuildContext context, MarketplaceListing listing) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Anzeige löschen'),
        content: Text(
          'Möchten Sie die Anzeige "${listing.title}" wirklich löschen? '
          'Diese Aktion kann nicht rückgängig gemacht werden.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Abbrechen'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _deleteListing(listing);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Löschen'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteListing(MarketplaceListing listing) async {
    try {
      await ref.read(marketplaceRepositoryProvider).deleteListing(listing.id);
      _refreshListings();

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Anzeige wurde gelöscht')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fehler beim Löschen: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

// Provider für eigene Listings
final myMarketplaceListingsProvider =
    FutureProvider.family<List<MarketplaceListing>, String>((
      ref,
      status,
    ) async {
      final repository = ref.read(marketplaceRepositoryProvider);
      return repository.getMyListings(status: status);
    });

// Provider für eigene Listing-Statistiken
final myListingStatisticsProvider = FutureProvider<Map<String, dynamic>>((
  ref,
) async {
  final repository = ref.read(marketplaceRepositoryProvider);
  return repository.getMyListingStatistics();
});
