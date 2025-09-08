import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/marketplace_models.dart';
import '../repository/marketplace_repository.dart';

class MarketplaceSearchBar extends ConsumerStatefulWidget {
  final Function(String)? onSearchChanged;
  final String? initialQuery;
  final bool autofocus;

  const MarketplaceSearchBar({
    super.key,
    this.onSearchChanged,
    this.initialQuery,
    this.autofocus = false,
  });

  @override
  ConsumerState<MarketplaceSearchBar> createState() =>
      _MarketplaceSearchBarState();
}

class _MarketplaceSearchBarState extends ConsumerState<MarketplaceSearchBar> {
  late final TextEditingController _controller;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialQuery);
    _hasText = widget.initialQuery?.isNotEmpty == true;
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final hasText = _controller.text.isNotEmpty;
    if (_hasText != hasText) {
      setState(() {
        _hasText = hasText;
      });
    }
  }

  void _onSubmitted(String query) {
    widget.onSearchChanged?.call(query.trim());
    ref.read(searchQueryProvider.notifier).state = query.trim();
    FocusScope.of(context).unfocus();
  }

  void _clearSearch() {
    _controller.clear();
    widget.onSearchChanged?.call('');
    ref.read(searchQueryProvider.notifier).state = '';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: TextField(
        controller: _controller,
        autofocus: widget.autofocus,
        decoration: InputDecoration(
          hintText: 'Suchen in Kleinanzeigen...',
          hintStyle: TextStyle(color: Colors.grey[600]),
          prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
          suffixIcon: _hasText
              ? IconButton(
                  icon: Icon(Icons.clear, color: Colors.grey[600]),
                  onPressed: _clearSearch,
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
        textInputAction: TextInputAction.search,
        onSubmitted: _onSubmitted,
        onChanged: (value) {
          // Optional: Real-time search as user types (debounced)
          // Uncomment if you want instant search
          // _debouncer.run(() => widget.onSearchChanged?.call(value.trim()));
        },
      ),
    );
  }
}

class MarketplaceSortDropdown extends ConsumerWidget {
  final Function(MarketplaceSortOrder)? onSortChanged;

  const MarketplaceSortDropdown({super.key, this.onSortChanged});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSort = ref.watch(sortOrderProvider);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<MarketplaceSortOrder>(
          value: currentSort,
          icon: const Icon(Icons.keyboard_arrow_down, size: 18),
          isDense: true,
          items: MarketplaceSortOrder.values.map((sortOrder) {
            return DropdownMenuItem(
              value: sortOrder,
              child: Text(
                _getSortLabel(sortOrder),
                style: const TextStyle(fontSize: 14),
              ),
            );
          }).toList(),
          onChanged: (sortOrder) {
            if (sortOrder != null) {
              ref.read(sortOrderProvider.notifier).state = sortOrder;
              onSortChanged?.call(sortOrder);
            }
          },
        ),
      ),
    );
  }

  String _getSortLabel(MarketplaceSortOrder sortOrder) {
    switch (sortOrder) {
      case MarketplaceSortOrder.newestFirst:
        return 'Neueste zuerst';
      case MarketplaceSortOrder.oldestFirst:
        return 'Älteste zuerst';
      case MarketplaceSortOrder.priceLowToHigh:
        return 'Preis: niedrig → hoch';
      case MarketplaceSortOrder.priceHighToLow:
        return 'Preis: hoch → niedrig';
      case MarketplaceSortOrder.titleAZ:
        return 'Titel: A → Z';
      case MarketplaceSortOrder.titleZA:
        return 'Titel: Z → A';
    }
  }
}

// Search suggestions widget for enhanced search experience
class MarketplaceSearchSuggestions extends ConsumerWidget {
  final String query;
  final Function(String) onSuggestionTap;

  const MarketplaceSearchSuggestions({
    super.key,
    required this.query,
    required this.onSuggestionTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (query.length < 2) {
      return _buildRecentSearches(context, ref);
    }

    return _buildSearchSuggestions(context, query);
  }

  Widget _buildRecentSearches(BuildContext context, WidgetRef ref) {
    // This would typically come from a stored list of recent searches
    final recentSearches = <String>['iPhone', 'Fahrrad', 'Sofa', 'Gartenmöbel'];

    if (recentSearches.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Letzte Suchen',
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(color: Colors.grey[600]),
          ),
        ),
        ...recentSearches.map(
          (search) => ListTile(
            leading: const Icon(Icons.history, color: Colors.grey),
            title: Text(search),
            onTap: () => onSuggestionTap(search),
            trailing: IconButton(
              icon: const Icon(Icons.close, size: 20),
              onPressed: () {
                // Remove from recent searches
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchSuggestions(BuildContext context, String query) {
    // This would typically come from an API call or cached suggestions
    final suggestions = _generateSuggestions(query);

    return Column(
      children: suggestions
          .map(
            (suggestion) => ListTile(
              leading: const Icon(Icons.search, color: Colors.grey),
              title: RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.bodyMedium,
                  children: _highlightMatch(suggestion, query),
                ),
              ),
              onTap: () => onSuggestionTap(suggestion),
            ),
          )
          .toList(),
    );
  }

  List<String> _generateSuggestions(String query) {
    // Mock suggestions - in real app this would come from API
    final allSuggestions = [
      'iPhone 13',
      'iPhone 12',
      'iPad Pro',
      'Fahrrad Mountainbike',
      'Fahrrad Rennrad',
      'Fahrrad Elektro',
      'Sofa Leder',
      'Sofa 3-Sitzer',
      'Gartenmöbel Set',
      'Gartenmöbel Holz',
    ];

    return allSuggestions
        .where(
          (suggestion) =>
              suggestion.toLowerCase().contains(query.toLowerCase()),
        )
        .take(5)
        .toList();
  }

  List<TextSpan> _highlightMatch(String text, String query) {
    if (query.isEmpty) {
      return [TextSpan(text: text)];
    }

    final matches = <TextSpan>[];
    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();

    int start = 0;
    int index = lowerText.indexOf(lowerQuery);

    while (index != -1) {
      // Add text before match
      if (index > start) {
        matches.add(TextSpan(text: text.substring(start, index)));
      }

      // Add highlighted match
      matches.add(
        TextSpan(
          text: text.substring(index, index + query.length),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      );

      start = index + query.length;
      index = lowerText.indexOf(lowerQuery, start);
    }

    // Add remaining text
    if (start < text.length) {
      matches.add(TextSpan(text: text.substring(start)));
    }

    return matches;
  }
}

// Quick filter chips for common searches
class MarketplaceQuickFilters extends StatelessWidget {
  final Function(String) onFilterTap;

  const MarketplaceQuickFilters({super.key, required this.onFilterTap});

  @override
  Widget build(BuildContext context) {
    final quickFilters = [
      {'label': '< 50€', 'query': 'price_max:50'},
      {'label': 'Neu', 'query': 'condition:new'},
      {'label': 'Heute', 'query': 'date:today'},
      {'label': 'Aukrug', 'query': 'area:aukrug'},
    ];

    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: quickFilters.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = quickFilters[index];
          return ActionChip(
            label: Text(filter['label']!),
            onPressed: () => onFilterTap(filter['query']!),
            backgroundColor: Colors.grey[100],
            side: BorderSide(color: Colors.grey[300]!),
          );
        },
      ),
    );
  }
}
