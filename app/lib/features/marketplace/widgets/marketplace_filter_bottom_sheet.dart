import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/marketplace_models.dart';
import '../providers/marketplace_providers.dart';
import '../widgets/marketplace_category_filter.dart';

class MarketplaceFilterBottomSheet extends ConsumerStatefulWidget {
  final Function(MarketplaceFilters) onFiltersChanged;

  const MarketplaceFilterBottomSheet({
    super.key,
    required this.onFiltersChanged,
  });

  @override
  ConsumerState<MarketplaceFilterBottomSheet> createState() =>
      _MarketplaceFilterBottomSheetState();
}

class _MarketplaceFilterBottomSheetState
    extends ConsumerState<MarketplaceFilterBottomSheet> {
  late MarketplaceFilters _filters;
  RangeValues _priceRange = const RangeValues(0, 1000);
  Set<int> _selectedCategories = {};
  String _selectedArea = '';
  double _maxDistance = 10.0;

  final List<String> _availableAreas = [
    'Aukrug',
    'Bargstedt',
    'Böken',
    'Ehndorf',
    'Homfeld',
    'Innien',
    'Padenstedt',
    'Sarlhusen',
  ];

  @override
  void initState() {
    super.initState();
    _filters = ref.read(marketplaceFiltersProvider);
    _initializeFromCurrentFilters();
  }

  void _initializeFromCurrentFilters() {
    setState(() {
      _priceRange = RangeValues(
        _filters.priceMin ?? 0,
        _filters.priceMax ?? 1000,
      );
      _selectedCategories = _filters.categoryIds?.toSet() ?? {};
      _selectedArea = _filters.locationArea ?? '';
      _maxDistance = _filters.maxDistance ?? 10.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            height: 4,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Filter',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                TextButton(
                  onPressed: _clearAllFilters,
                  child: const Text('Zurücksetzen'),
                ),
              ],
            ),
          ),

          // Filter content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Price Range
                  _buildPriceRangeSection(),

                  const SizedBox(height: 32),

                  // Categories
                  _buildCategoriesSection(),

                  const SizedBox(height: 32),

                  // Location
                  _buildLocationSection(),

                  const SizedBox(height: 32),

                  // Additional Options
                  _buildAdditionalOptionsSection(),

                  const SizedBox(height: 100), // Space for floating button
                ],
              ),
            ),
          ),

          // Apply Button
          _buildApplyButton(),
        ],
      ),
    );
  }

  Widget _buildPriceRangeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Preisspanne',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),

        Row(
          children: [
            Expanded(
              child: TextField(
                decoration: const InputDecoration(
                  labelText: 'Von (€)',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                keyboardType: TextInputType.number,
                controller: TextEditingController(
                  text: _priceRange.start.round().toString(),
                ),
                onChanged: (value) {
                  final price = double.tryParse(value) ?? 0;
                  setState(() {
                    _priceRange = RangeValues(price, _priceRange.end);
                  });
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextField(
                decoration: const InputDecoration(
                  labelText: 'Bis (€)',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                keyboardType: TextInputType.number,
                controller: TextEditingController(
                  text: _priceRange.end.round().toString(),
                ),
                onChanged: (value) {
                  final price = double.tryParse(value) ?? 1000;
                  setState(() {
                    _priceRange = RangeValues(_priceRange.start, price);
                  });
                },
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        RangeSlider(
          values: _priceRange,
          min: 0,
          max: 2000,
          divisions: 40,
          labels: RangeLabels(
            '${_priceRange.start.round()}€',
            '${_priceRange.end.round()}€',
          ),
          onChanged: (values) {
            setState(() {
              _priceRange = values;
            });
          },
        ),
      ],
    );
  }

  Widget _buildCategoriesSection() {
    final categoriesAsync = ref.watch(categoriesProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Kategorien',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),

        categoriesAsync.when(
          data: (categories) => MarketplaceCategoryTree(
            categories: categories,
            selectedCategoryIds: _selectedCategories,
            onCategoriesSelected: (selected) {
              setState(() {
                _selectedCategories = selected;
              });
            },
            multiSelect: true,
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Text(
            'Fehler beim Laden der Kategorien: $error',
            style: TextStyle(color: Colors.red[700]),
          ),
        ),
      ],
    );
  }

  Widget _buildLocationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Standort',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),

        // Area Dropdown
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            labelText: 'Bereich auswählen',
            border: OutlineInputBorder(),
            isDense: true,
          ),
          value: _selectedArea.isEmpty ? null : _selectedArea,
          items: [
            const DropdownMenuItem<String>(
              value: '',
              child: Text('Alle Bereiche'),
            ),
            ..._availableAreas.map(
              (area) =>
                  DropdownMenuItem<String>(value: area, child: Text(area)),
            ),
          ],
          onChanged: (value) {
            setState(() {
              _selectedArea = value ?? '';
            });
          },
        ),

        if (_selectedArea.isNotEmpty) ...[
          const SizedBox(height: 16),

          // Distance Slider
          Text(
            'Maximale Entfernung: ${_maxDistance.round()} km',
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),

          Slider(
            value: _maxDistance,
            min: 1,
            max: 50,
            divisions: 49,
            label: '${_maxDistance.round()} km',
            onChanged: (value) {
              setState(() {
                _maxDistance = value;
              });
            },
          ),
        ],
      ],
    );
  }

  Widget _buildAdditionalOptionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Zusätzliche Optionen',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),

        CheckboxListTile(
          title: const Text('Nur Favoriten'),
          subtitle: const Text('Zeige nur meine favorisierten Anzeigen'),
          value: _filters.onlyFavorites,
          onChanged: (value) {
            setState(() {
              _filters = _filters.copyWith(onlyFavorites: value ?? false);
            });
          },
          controlAffinity: ListTileControlAffinity.leading,
        ),

        const Divider(),

        ListTile(
          title: const Text('Status'),
          subtitle: Text(_getStatusDisplayText(_filters.status)),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () => _showStatusPicker(),
        ),
      ],
    );
  }

  Widget _buildApplyButton() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _applyFilters,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Filter anwenden',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }

  void _clearAllFilters() {
    setState(() {
      _filters = const MarketplaceFilters();
      _priceRange = const RangeValues(0, 1000);
      _selectedCategories = {};
      _selectedArea = '';
      _maxDistance = 10.0;
    });
  }

  void _applyFilters() {
    final appliedFilters = _filters.copyWith(
      priceMin: _priceRange.start > 0 ? _priceRange.start : null,
      priceMax: _priceRange.end < 2000 ? _priceRange.end : null,
      categoryIds: _selectedCategories.isNotEmpty
          ? _selectedCategories.toList()
          : null,
      locationArea: _selectedArea.isNotEmpty ? _selectedArea : null,
      maxDistance: _selectedArea.isNotEmpty ? _maxDistance : null,
      page: 1, // Reset to first page when applying filters
    );

    widget.onFiltersChanged(appliedFilters);
    Navigator.of(context).pop();
  }

  void _showStatusPicker() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Status auswählen'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('Alle'),
              value: 'all',
              groupValue: _filters.status,
              onChanged: (value) {
                setState(() {
                  _filters = _filters.copyWith(status: value!);
                });
                Navigator.of(context).pop();
              },
            ),
            RadioListTile<String>(
              title: const Text('Aktiv'),
              value: 'active',
              groupValue: _filters.status,
              onChanged: (value) {
                setState(() {
                  _filters = _filters.copyWith(status: value!);
                });
                Navigator.of(context).pop();
              },
            ),
            RadioListTile<String>(
              title: const Text('Verkauft'),
              value: 'sold',
              groupValue: _filters.status,
              onChanged: (value) {
                setState(() {
                  _filters = _filters.copyWith(status: value!);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  String _getStatusDisplayText(String status) {
    switch (status) {
      case 'active':
        return 'Nur aktive Anzeigen';
      case 'sold':
        return 'Nur verkaufte Anzeigen';
      default:
        return 'Alle Anzeigen';
    }
  }
}

// Quick filter chips that can be used above the main content
class MarketplaceActiveFilters extends ConsumerWidget {
  final Function() onClearAll;

  const MarketplaceActiveFilters({super.key, required this.onClearAll});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filters = ref.watch(marketplaceFiltersProvider);
    final categories = ref.watch(categoriesProvider).value ?? [];

    final activeFilters = _buildActiveFilterChips(filters, categories);

    if (activeFilters.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: activeFilters.length + 1, // +1 for clear all button
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          if (index == activeFilters.length) {
            return ActionChip(
              label: const Text('Alle löschen'),
              onPressed: onClearAll,
              backgroundColor: Colors.red[50],
              side: BorderSide(color: Colors.red[300]!),
              labelStyle: TextStyle(color: Colors.red[700]),
            );
          }
          return activeFilters[index];
        },
      ),
    );
  }

  List<Widget> _buildActiveFilterChips(
    MarketplaceFilters filters,
    List<MarketplaceCategory> categories,
  ) {
    final chips = <Widget>[];

    // Price filter
    if (filters.priceMin != null || filters.priceMax != null) {
      String priceText = '';
      if (filters.priceMin != null && filters.priceMax != null) {
        priceText =
            '${filters.priceMin!.round()}€ - ${filters.priceMax!.round()}€';
      } else if (filters.priceMin != null) {
        priceText = 'Ab ${filters.priceMin!.round()}€';
      } else {
        priceText = 'Bis ${filters.priceMax!.round()}€';
      }

      chips.add(
        Chip(
          label: Text(priceText),
          backgroundColor: Colors.blue[50],
          side: BorderSide(color: Colors.blue[300]!),
        ),
      );
    }

    // Category filters
    if (filters.categoryIds != null && filters.categoryIds!.isNotEmpty) {
      for (final categoryId in filters.categoryIds!) {
        final category = categories.cast<MarketplaceCategory?>().firstWhere(
          (cat) => cat?.id == categoryId,
          orElse: () => null,
        );

        if (category != null) {
          chips.add(
            Chip(
              label: Text(category.name),
              backgroundColor: Colors.green[50],
              side: BorderSide(color: Colors.green[300]!),
            ),
          );
        }
      }
    }

    // Location filter
    if (filters.locationArea != null && filters.locationArea!.isNotEmpty) {
      chips.add(
        Chip(
          label: Text(filters.locationArea!),
          backgroundColor: Colors.orange[50],
          side: BorderSide(color: Colors.orange[300]!),
        ),
      );
    }

    // Favorites filter
    if (filters.onlyFavorites) {
      chips.add(
        Chip(
          label: const Text('Favoriten'),
          backgroundColor: Colors.red[50],
          side: BorderSide(color: Colors.red[300]!),
        ),
      );
    }

    return chips;
  }
}
