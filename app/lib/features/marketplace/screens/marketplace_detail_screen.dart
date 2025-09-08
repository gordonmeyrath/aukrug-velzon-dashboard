import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/widgets/app_bar.dart';
import '../../../core/widgets/error_widget.dart';
import '../../../core/widgets/loading_widget.dart';
import '../models/marketplace_models.dart';
import '../providers/marketplace_providers.dart';
import '../widgets/marketplace_contact_dialog.dart';
import '../widgets/marketplace_image_gallery.dart';
import '../widgets/marketplace_report_dialog.dart';

class MarketplaceDetailScreen extends ConsumerStatefulWidget {
  final int listingId;

  const MarketplaceDetailScreen({super.key, required this.listingId});

  @override
  ConsumerState<MarketplaceDetailScreen> createState() =>
      _MarketplaceDetailScreenState();
}

class _MarketplaceDetailScreenState
    extends ConsumerState<MarketplaceDetailScreen> {
  final PageController _pageController = PageController();
  int _currentImageIndex = 0;
  bool _isFavorite = false;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer(
        builder: (context, ref, child) {
          final listingAsync = ref.watch(_listingProvider);
          // final verificationStatus = ref.watch(verificationStatusProvider);

          return listingAsync.when(
            data: (listing) => listing != null
                ? _buildDetailContent(context, ref, listing)
                : _buildNotFoundContent(context),
            loading: () => const Center(child: LoadingWidget()),
            error: (error, stack) => Center(
              child: AukrugErrorWidget(
                message: 'Fehler beim Laden der Anzeige',
                onRetry: () => ref.invalidate(_listingProvider),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailContent(
    BuildContext context,
    WidgetRef ref,
    MarketplaceListing listing,
  ) {
    _isFavorite = listing.isFavorite;

    return CustomScrollView(
      slivers: [
        // Image Gallery App Bar
        _buildImageGalleryAppBar(context, ref, listing),

        // Content
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              // Title and Price
              _buildTitlePriceSection(context, listing),

              const SizedBox(height: 24),

              // Quick Info Cards
              _buildQuickInfoSection(context, listing),

              const SizedBox(height: 24),

              // Description
              _buildDescriptionSection(context, listing),

              const SizedBox(height: 24),

              // Location and Author
              _buildLocationAuthorSection(context, listing),

              const SizedBox(height: 24),

              // Actions (only for non-owners)
              if (!listing.isOwner) ...[
                _buildActionButtons(context, ref, listing),
                const SizedBox(height: 24),
              ],

              // Owner Actions (only for owners)
              if (listing.isOwner) ...[
                _buildOwnerActions(context, ref, listing),
                const SizedBox(height: 24),
              ],

              // Safety Tips
              _buildSafetyTips(context),

              const SizedBox(height: 100), // Space for floating button
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildImageGalleryAppBar(
    BuildContext context,
    WidgetRef ref,
    MarketplaceListing listing,
  ) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      backgroundColor: Colors.black,
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.7),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        onPressed: () => context.pop(),
      ),
      actions: [
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: _isFavorite ? Colors.red : Colors.white,
            ),
          ),
          onPressed: () => _toggleFavorite(ref, listing),
        ),
        PopupMenuButton<String>(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.more_vert, color: Colors.white),
          ),
          onSelected: (value) =>
              _handleMenuAction(context, ref, listing, value),
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'share',
              child: ListTile(
                leading: Icon(Icons.share),
                title: Text('Teilen'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            if (!listing.isOwner)
              const PopupMenuItem(
                value: 'report',
                child: ListTile(
                  leading: Icon(Icons.report, color: Colors.red),
                  title: Text('Melden', style: TextStyle(color: Colors.red)),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
          ],
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: listing.images.isNotEmpty
            ? _buildImageCarousel(listing)
            : _buildPlaceholderImage(),
      ),
    );
  }

  Widget _buildImageCarousel(MarketplaceListing listing) {
    return Stack(
      children: [
        PageView.builder(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentImageIndex = index;
            });
          },
          itemCount: listing.images.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => _openImageGallery(listing, index),
              child: Hero(
                tag: 'listing-image-${listing.id}-$index',
                child: CachedNetworkImage(
                  imageUrl: listing.images[index],
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Colors.grey[200],
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[200],
                    child: const Icon(Icons.image_not_supported, size: 64),
                  ),
                ),
              ),
            );
          },
        ),

        // Image Counter
        if (listing.images.length > 1)
          Positioned(
            bottom: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${_currentImageIndex + 1} / ${listing.images.length}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

        // Navigation Arrows (for desktop/tablet)
        if (listing.images.length > 1) ...[
          Positioned(
            left: 16,
            top: 0,
            bottom: 0,
            child: Center(
              child: IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_back_ios, color: Colors.white),
                ),
                onPressed: _currentImageIndex > 0
                    ? () => _pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      )
                    : null,
              ),
            ),
          ),
          Positioned(
            right: 16,
            top: 0,
            bottom: 0,
            child: Center(
              child: IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                  ),
                ),
                onPressed: _currentImageIndex < listing.images.length - 1
                    ? () => _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      )
                    : null,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      color: Colors.grey[200],
      child: const Center(
        child: Icon(Icons.image, size: 64, color: Colors.grey),
      ),
    );
  }

  Widget _buildTitlePriceSection(
    BuildContext context,
    MarketplaceListing listing,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                listing.title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            _buildStatusChip(context, listing),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          listing.formattedPrice,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusChip(BuildContext context, MarketplaceListing listing) {
    if (listing.isActive) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: listing.statusColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        listing.statusDisplayText,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildQuickInfoSection(
    BuildContext context,
    MarketplaceListing listing,
  ) {
    return Row(
      children: [
        Expanded(
          child: _buildInfoCard(
            context,
            icon: Icons.location_on_outlined,
            title: 'Standort',
            subtitle: listing.locationArea,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildInfoCard(
            context,
            icon: Icons.schedule,
            title: 'Erstellt',
            subtitle: listing.relativeTimeString,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildInfoCard(
            context,
            icon: Icons.visibility_outlined,
            title: 'Aufrufe',
            subtitle: '${listing.viewCount}',
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Icon(icon, color: Theme.of(context).primaryColor, size: 20),
          const SizedBox(height: 4),
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection(
    BuildContext context,
    MarketplaceListing listing,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Beschreibung',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Text(
            listing.description,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ],
    );
  }

  Widget _buildLocationAuthorSection(
    BuildContext context,
    MarketplaceListing listing,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Anbieter',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: Theme.of(context).primaryColor,
                child: Text(
                  listing.authorName.isNotEmpty
                      ? listing.authorName[0].toUpperCase()
                      : '?',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      listing.authorName,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          listing.locationArea,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (listing.contactViaMessenger)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.message, size: 16, color: Colors.blue[700]),
                      const SizedBox(width: 4),
                      Text(
                        'Messenger',
                        style: TextStyle(
                          color: Colors.blue[700],
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    WidgetRef ref,
    MarketplaceListing listing,
  ) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => _showContactDialog(context, listing),
            icon: const Icon(Icons.message),
            label: const Text('Nachricht senden'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _shareListing(listing),
                icon: const Icon(Icons.share),
                label: const Text('Teilen'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _showReportDialog(context, listing),
                icon: const Icon(Icons.flag, color: Colors.red),
                label: const Text(
                  'Melden',
                  style: TextStyle(color: Colors.red),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  side: const BorderSide(color: Colors.red),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOwnerActions(
    BuildContext context,
    WidgetRef ref,
    MarketplaceListing listing,
  ) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () =>
                    context.push('/marketplace/edit/${listing.id}'),
                icon: const Icon(Icons.edit),
                label: const Text('Bearbeiten'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: listing.isActive
                    ? () => _updateStatus(
                        ref,
                        listing,
                        MarketplaceListingStatus.paused,
                      )
                    : () => _updateStatus(
                        ref,
                        listing,
                        MarketplaceListingStatus.active,
                      ),
                icon: Icon(listing.isActive ? Icons.pause : Icons.play_arrow),
                label: Text(listing.isActive ? 'Pausieren' : 'Aktivieren'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: listing.isSold
                    ? () => _updateStatus(
                        ref,
                        listing,
                        MarketplaceListingStatus.active,
                      )
                    : () => _updateStatus(
                        ref,
                        listing,
                        MarketplaceListingStatus.sold,
                      ),
                icon: Icon(listing.isSold ? Icons.undo : Icons.check_circle),
                label: Text(
                  listing.isSold
                      ? 'Als verfügbar markieren'
                      : 'Als verkauft markieren',
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSafetyTips(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.security, color: Colors.blue[700], size: 20),
              const SizedBox(width: 8),
              Text(
                'Sicherheitshinweise',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.blue[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '• Treffen Sie sich an öffentlichen Orten\n'
            '• Prüfen Sie den Artikel vor dem Kauf\n'
            '• Seien Sie vorsichtig bei Vorauszahlungen\n'
            '• Melden Sie verdächtige Anzeigen',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.blue[700]),
          ),
        ],
      ),
    );
  }

  Widget _buildNotFoundContent(BuildContext context) {
    return Scaffold(
      appBar: AukrugAppBar(title: 'Anzeige nicht gefunden'),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Diese Anzeige wurde nicht gefunden oder ist nicht mehr verfügbar.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  // Event Handlers
  void _toggleFavorite(WidgetRef ref, MarketplaceListing listing) async {
    try {
      final isFavorite = await ref
          .read(marketplaceRepositoryProvider)
          .toggleFavorite(listing.id);

      setState(() {
        _isFavorite = isFavorite;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isFavorite ? 'Zu Favoriten hinzugefügt' : 'Von Favoriten entfernt',
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Fehler beim Aktualisieren der Favoriten'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _handleMenuAction(
    BuildContext context,
    WidgetRef ref,
    MarketplaceListing listing,
    String action,
  ) {
    switch (action) {
      case 'share':
        _shareListing(listing);
        break;
      case 'report':
        _showReportDialog(context, listing);
        break;
    }
  }

  void _shareListing(MarketplaceListing listing) {
    final text =
        '${listing.title}\n${listing.formattedPrice}\n\nAukrug Kleinanzeigen';
    Share.share(text, subject: listing.title);
  }

  void _showContactDialog(BuildContext context, MarketplaceListing listing) {
    showDialog(
      context: context,
      builder: (context) => MarketplaceContactDialog(listing: listing),
    );
  }

  void _showReportDialog(BuildContext context, MarketplaceListing listing) {
    showDialog(
      context: context,
      builder: (context) => MarketplaceReportDialog(listing: listing),
    );
  }

  void _openImageGallery(MarketplaceListing listing, int initialIndex) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MarketplaceImageGallery(
          images: listing.images,
          initialIndex: initialIndex,
          heroTagPrefix: 'listing-image-${listing.id}',
        ),
      ),
    );
  }

  void _updateStatus(
    WidgetRef ref,
    MarketplaceListing listing,
    MarketplaceListingStatus status,
  ) async {
    try {
      await ref
          .read(marketplaceRepositoryProvider)
          .updateListingStatus(listing.id, status);

      // Invalidate the listing to reload with new status
      ref.invalidate(_listingProvider);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Status erfolgreich aktualisiert')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Fehler beim Aktualisieren des Status'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Providers
  late final _listingProvider = FutureProvider<MarketplaceListing?>((ref) {
    final repository = ref.watch(marketplaceRepositoryProvider);
    return repository.getListing(widget.listingId);
  });
}
