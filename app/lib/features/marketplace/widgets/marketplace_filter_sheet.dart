import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/marketplace_models.dart';
import '../providers/marketplace_providers.dart';

class MarketplaceFilterSheet extends ConsumerStatefulWidget {
  const MarketplaceFilterSheet({super.key});

  @override
  ConsumerState<MarketplaceFilterSheet> createState() =>
      _MarketplaceFilterSheetState();
}

class _MarketplaceFilterSheetState
    extends ConsumerState<MarketplaceFilterSheet> {
  late MarketplaceFilters _filters;

  @override
  void initState() {
    super.initState();
    _filters = ref.read(marketplaceFiltersProvider);
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      maxChildSize: 0.9,
      minChildSize: 0.5,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const Text(
                'Filter',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  children: [
                    _buildPriceFilter(),
                    const Divider(),
                    _buildLocationFilter(),
                    const Divider(),
                    _buildStatusFilter(),
                  ],
                ),
              ),
              _buildActionButtons(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPriceFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Preis', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                initialValue: _filters.priceMin?.toString() ?? '',
                decoration: const InputDecoration(
                  labelText: 'Min',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  final price = double.tryParse(value);
                  _filters = _filters.copyWith(priceMin: price);
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextFormField(
                initialValue: _filters.priceMax?.toString() ?? '',
                decoration: const InputDecoration(
                  labelText: 'Max',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  final price = double.tryParse(value);
                  _filters = _filters.copyWith(priceMax: price);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLocationFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Standort', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: _filters.locationArea ?? '',
          decoration: const InputDecoration(
            labelText: 'Bereich',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            _filters = _filters.copyWith(
              locationArea: value.isEmpty ? null : value,
            );
          },
        ),
      ],
    );
  }

  Widget _buildStatusFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Status', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _filters.status,
          decoration: const InputDecoration(
            labelText: 'Status',
            border: OutlineInputBorder(),
          ),
          items: const [
            DropdownMenuItem(value: null, child: Text('Alle')),
            DropdownMenuItem(value: 'active', child: Text('Aktiv')),
            DropdownMenuItem(value: 'paused', child: Text('Pausiert')),
            DropdownMenuItem(value: 'sold', child: Text('Verkauft')),
          ],
          onChanged: (value) {
            _filters = _filters.copyWith(status: value);
          },
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(top: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                // Reset filters
                _filters = const MarketplaceFilters(
                  categoryIds: [],
                  priceMin: null,
                  priceMax: null,
                  locationArea: null,
                  maxDistance: null,
                  status: null,
                  sortBy: 'created_at',
                  sortOrder: 'desc',
                  onlyFavorites: false,
                );
                ref.read(marketplaceFiltersProvider.notifier).state = _filters;
              },
              child: const Text('Zurücksetzen'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: FilledButton(
              onPressed: () {
                ref.read(marketplaceFiltersProvider.notifier).state = _filters;
                Navigator.of(context).pop();
              },
              child: const Text('Anwenden'),
            ),
          ),
        ],
      ),
    );
  }
}
