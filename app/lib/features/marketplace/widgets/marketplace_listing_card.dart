import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../models/marketplace_models.dart';

class MarketplaceListingCard extends StatelessWidget {
  final MarketplaceListing listing;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteToggle;
  final bool showFavoriteButton;
  final bool compact;

  const MarketplaceListingCard({
    super.key,
    required this.listing,
    this.onTap,
    this.onFavoriteToggle,
    this.showFavoriteButton = true,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            _buildImageSection(context),

            // Content Section
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and Status
                    _buildTitleRow(context),

                    const SizedBox(height: 8),

                    // Price
                    _buildPriceSection(context),

                    const SizedBox(height: 8),

                    // Location and Time
                    _buildLocationTimeRow(context),

                    const Spacer(),

                    // Author
                    if (!compact) _buildAuthorSection(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection(BuildContext context) {
    return Stack(
      children: [
        // Main Image
        Container(
          height: compact ? 120 : 160,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            color: Colors.grey[200],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: listing.primaryImageUrl.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: listing.primaryImageUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Colors.grey[200],
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey[200],
                      child: const Icon(
                        Icons.image_not_supported,
                        color: Colors.grey,
                        size: 48,
                      ),
                    ),
                  )
                : Container(
                    color: Colors.grey[200],
                    child: const Icon(
                      Icons.image,
                      color: Colors.grey,
                      size: 48,
                    ),
                  ),
          ),
        ),

        // Status Badge
        if (!listing.isActive)
          Positioned(
            top: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: listing.statusColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                listing.statusDisplayText,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

        // Favorite Button
        if (showFavoriteButton && onFavoriteToggle != null)
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: onFavoriteToggle,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Icon(
                  listing.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: listing.isFavorite ? Colors.red : Colors.grey[600],
                  size: 20,
                ),
              ),
            ),
          ),

        // Multiple Images Indicator
        if (listing.hasMultipleImages)
          Positioned(
            bottom: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.photo_library,
                    color: Colors.white,
                    size: 14,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    '${listing.images.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildTitleRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            listing.title,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
            maxLines: compact ? 1 : 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (listing.contactViaMessenger)
          const Icon(Icons.message, size: 16, color: Colors.blue),
      ],
    );
  }

  Widget _buildPriceSection(BuildContext context) {
    return Text(
      listing.formattedPrice,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
        color: Theme.of(context).primaryColor,
      ),
    );
  }

  Widget _buildLocationTimeRow(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.location_on_outlined, size: 14, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            listing.locationArea,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          listing.relativeTimeString,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildAuthorSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey[300]!, width: 0.5)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 12,
            backgroundColor: Theme.of(context).primaryColor,
            child: Text(
              listing.authorName.isNotEmpty
                  ? listing.authorName[0].toUpperCase()
                  : '?',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              listing.authorName,
              style: Theme.of(context).textTheme.bodySmall,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (listing.viewCount > 0) ...[
            Icon(Icons.visibility_outlined, size: 14, color: Colors.grey[600]),
            const SizedBox(width: 2),
            Text(
              '${listing.viewCount}',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
            ),
          ],
        ],
      ),
    );
  }
}

// Compact version for lists
class MarketplaceListingListTile extends StatelessWidget {
  final MarketplaceListing listing;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteToggle;

  const MarketplaceListingListTile({
    super.key,
    required this.listing,
    this.onTap,
    this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: 60,
            height: 60,
            color: Colors.grey[200],
            child: listing.primaryImageUrl.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: listing.primaryImageUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const Icon(Icons.image),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.image_not_supported),
                  )
                : const Icon(Icons.image),
          ),
        ),
        title: Text(
          listing.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              listing.formattedPrice,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            Text(
              '${listing.locationArea} • ${listing.relativeTimeString}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        trailing: onFavoriteToggle != null
            ? IconButton(
                icon: Icon(
                  listing.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: listing.isFavorite ? Colors.red : null,
                ),
                onPressed: onFavoriteToggle,
              )
            : null,
        onTap: onTap,
      ),
    );
  }
}
