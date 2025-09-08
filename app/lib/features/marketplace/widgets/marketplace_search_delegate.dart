import 'package:flutter/material.dart';

import '../models/marketplace_models.dart';

class MarketplaceSearchDelegate extends SearchDelegate<MarketplaceListing?> {
  final List<MarketplaceListing> listings;

  MarketplaceSearchDelegate({required this.listings});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(icon: const Icon(Icons.clear), onPressed: () => query = ''),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    final results = listings.where((listing) {
      return listing.title.toLowerCase().contains(query.toLowerCase()) ||
          listing.description.toLowerCase().contains(query.toLowerCase());
    }).toList();

    if (results.isEmpty) {
      return const Center(child: Text('Keine Ergebnisse gefunden'));
    }

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final listing = results[index];
        return ListTile(
          leading: listing.images.isNotEmpty
              ? CircleAvatar(
                  backgroundImage: NetworkImage(listing.images.first),
                )
              : const CircleAvatar(child: Icon(Icons.image)),
          title: Text(listing.title),
          subtitle: Text(
            listing.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Text(listing.formattedPrice),
          onTap: () => close(context, listing),
        );
      },
    );
  }
}
