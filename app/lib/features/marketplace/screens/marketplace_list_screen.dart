import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/app_bar.dart';
import '../../../core/widgets/empty_state_widget.dart';
import '../../../core/widgets/error_widget.dart';
import '../../../core/widgets/loading_widget.dart';
import '../controllers/marketplace_list_controller.dart';
import '../models/marketplace_models.dart';
import '../repository/marketplace_repository.dart';
import '../widgets/marketplace_category_filter.dart';
import '../widgets/marketplace_filter_bottom_sheet.dart';
import '../widgets/marketplace_listing_card.dart';
import '../widgets/marketplace_search_bar.dart';
import '../widgets/marketplace_sort_dropdown.dart';

class MarketplaceListScreen extends ConsumerStatefulWidget {
  const MarketplaceListScreen({super.key});

  @override
  ConsumerState<MarketplaceListScreen> createState() =>
      _MarketplaceListScreenState();
}

class _MarketplaceListScreenState extends ConsumerState<MarketplaceListScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      // Load more listings when near bottom
      ref.read(marketplaceListControllerProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final listingsState = ref.watch(marketplaceListControllerProvider);
    final verificationStatus = ref.watch(verificationStatusProvider);
    final categories = ref.watch(categoriesProvider);

    return Scaffold(
      appBar: AukrugAppBar(
        title: 'Kleinanzeigen',
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _showSearchDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.tune),
            onPressed: () => _showFilterBottomSheet(context),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(marketplaceListControllerProvider.notifier).refresh();
        },
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // Verification Status Banner
            verificationStatus.when(
              data: (status) => !status.canCreateListings
                  ? _buildVerificationBanner(context, status)
                  : const SliverToBoxAdapter(),
              loading: () => const SliverToBoxAdapter(),
              error: (_, __) => const SliverToBoxAdapter(),
            ),

            // Category Filter
            categories.when(
              data: (categoryList) => SliverToBoxAdapter(
                child: MarketplaceCategoryFilter(categories: categoryList),
              ),
              loading: () => const SliverToBoxAdapter(),
              error: (_, __) => const SliverToBoxAdapter(),
            ),

            // Search and Sort Controls
            SliverToBoxAdapter(child: _buildControlsSection()),

            // Listings Grid
            listingsState.when(
              data: (listings) => _buildListingsGrid(listings),
              loading: () => const SliverFillRemaining(
                child: Center(child: LoadingWidget()),
              ),
              error: (error, stack) => SliverFillRemaining(
                child: Center(
                  child: AukrugErrorWidget(
                    message: 'Fehler beim Laden der Anzeigen',
                    onRetry: () =>
                        ref.invalidate(marketplaceListControllerProvider),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: verificationStatus.when(
        data: (status) => status.canCreateListings
            ? FloatingActionButton.extended(
                onPressed: () => context.push('/marketplace/create'),
                icon: const Icon(Icons.add),
                label: const Text('Anzeige erstellen'),
              )
            : null,
        loading: () => null,
        error: (_, __) => null,
      ),
    );
  }

  Widget _buildVerificationBanner(
    BuildContext context,
    VerificationStatus status,
  ) {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: status.hasPendingRequest
              ? Colors.orange.shade100
              : Colors.red.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: status.hasPendingRequest
                ? Colors.orange.shade300
                : Colors.red.shade300,
          ),
        ),
        child: Row(
          children: [
            Icon(status.statusIcon, color: status.statusColor, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    status.displayStatus,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    status.hasPendingRequest
                        ? 'Deine Verifikation wird geprüft. Du wirst benachrichtigt, sobald sie abgeschlossen ist.'
                        : 'Um Anzeigen zu erstellen, musst du dich als Einwohner oder Unternehmen verifizieren lassen.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            if (!status.hasPendingRequest)
              TextButton(
                onPressed: () => context.push('/marketplace/verification'),
                child: const Text('Verifizieren'),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlsSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: MarketplaceSearchBar(
              onSearchChanged: (query) {
                ref.read(searchQueryProvider.notifier).state = query;
                ref
                    .read(marketplaceListControllerProvider.notifier)
                    .search(query);
              },
            ),
          ),
          const SizedBox(width: 12),
          MarketplaceSortDropdown(
            onSortChanged: (sortOrder) {
              ref.read(sortOrderProvider.notifier).state = sortOrder;
              ref
                  .read(marketplaceListControllerProvider.notifier)
                  .setSortOrder(sortOrder);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildListingsGrid(PaginatedResponse<MarketplaceListing> response) {
    if (response.data.isEmpty) {
      return const SliverFillRemaining(
        child: Center(
          child: EmptyStateWidget(
            title: 'Keine Anzeigen gefunden',
            subtitle:
                'Es gibt aktuell keine Anzeigen, die deinen Filterkriterien entsprechen.',
            icon: Icons.inventory_2_outlined,
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.7,
        ),
        delegate: SliverChildBuilderDelegate((context, index) {
          final listing = response.data[index];
          return MarketplaceListingCard(
            listing: listing,
            onTap: () => context.push('/marketplace/listing/${listing.id}'),
            onFavoriteToggle: () => _toggleFavorite(listing),
          );
        }, childCount: response.data.length),
      ),
    );
  }

  void _toggleFavorite(MarketplaceListing listing) {
    ref
        .read(marketplaceRepositoryProvider)
        .toggleFavorite(listing.id)
        .then((isFavorite) {
          // Update the listing in the list
          ref
              .read(marketplaceListControllerProvider.notifier)
              .updateListingFavoriteStatus(listing.id, isFavorite);

          // Show feedback
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                isFavorite
                    ? 'Zu Favoriten hinzugefügt'
                    : 'Von Favoriten entfernt',
              ),
              duration: const Duration(seconds: 2),
            ),
          );
        })
        .catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Fehler beim Aktualisieren der Favoriten'),
              backgroundColor: Colors.red,
            ),
          );
        });
  }

  void _showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Suchen'),
        content: TextField(
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Suchbegriff eingeben...',
            border: OutlineInputBorder(),
          ),
          onSubmitted: (query) {
            Navigator.of(context).pop();
            ref.read(searchQueryProvider.notifier).state = query;
            ref.read(marketplaceListControllerProvider.notifier).search(query);
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Abbrechen'),
          ),
        ],
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => MarketplaceFilterBottomSheet(
        onFiltersChanged: (filters) {
          ref.read(marketplaceFiltersProvider.notifier).state = filters;
          ref
              .read(marketplaceListControllerProvider.notifier)
              .applyFilters(filters);
        },
      ),
    );
  }
}

// Additional widgets for better organization
