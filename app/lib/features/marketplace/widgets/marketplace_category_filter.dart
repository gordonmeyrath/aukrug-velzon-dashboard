import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/marketplace_models.dart';
import '../repository/marketplace_repository.dart';

class MarketplaceCategoryFilter extends ConsumerWidget {
  final List<MarketplaceCategory> categories;
  final Function(int?)? onCategorySelected;

  const MarketplaceCategoryFilter({
    super.key,
    required this.categories,
    this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategoryId = ref.watch(selectedCategoryProvider);

    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length + 1, // +1 for "All" chip
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          if (index == 0) {
            // "All Categories" chip
            return _buildCategoryChip(
              context: context,
              category: null,
              label: 'Alle',
              icon: Icons.apps,
              isSelected: selectedCategoryId == null,
              onSelected: () {
                ref.read(selectedCategoryProvider.notifier).state = null;
                onCategorySelected?.call(null);
              },
            );
          }

          final category = categories[index - 1];
          return _buildCategoryChip(
            context: context,
            category: category,
            label: category.name,
            icon: _getCategoryIcon(category.iconName),
            isSelected: selectedCategoryId == category.id,
            onSelected: () {
              ref.read(selectedCategoryProvider.notifier).state = category.id;
              onCategorySelected?.call(category.id);
            },
          );
        },
      ),
    );
  }

  Widget _buildCategoryChip({
    required BuildContext context,
    required MarketplaceCategory? category,
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onSelected,
  }) {
    return FilterChip(
      selected: isSelected,
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: isSelected
                ? Theme.of(context).primaryColor
                : Colors.grey[600],
          ),
          const SizedBox(width: 6),
          Text(label),
          if (category?.count != null && category!.count > 0) ...[
            const SizedBox(width: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected
                    ? Theme.of(context).primaryColor.withOpacity(0.2)
                    : Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${category.count}',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? Theme.of(context).primaryColor
                      : Colors.grey[600],
                ),
              ),
            ),
          ],
        ],
      ),
      onSelected: (_) => onSelected(),
      backgroundColor: Colors.grey[100],
      selectedColor: Theme.of(context).primaryColor.withOpacity(0.1),
      checkmarkColor: Theme.of(context).primaryColor,
      labelStyle: TextStyle(
        color: isSelected ? Theme.of(context).primaryColor : Colors.grey[700],
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
    );
  }

  IconData _getCategoryIcon(String? iconName) {
    switch (iconName?.toLowerCase()) {
      case 'electronics':
        return Icons.devices;
      case 'furniture':
        return Icons.chair_outlined;
      case 'clothing':
        return Icons.checkroom;
      case 'books':
        return Icons.book_outlined;
      case 'sports':
        return Icons.sports_soccer;
      case 'toys':
        return Icons.toys;
      case 'garden':
        return Icons.yard;
      case 'tools':
        return Icons.build;
      case 'vehicles':
        return Icons.directions_car;
      case 'home':
        return Icons.home_outlined;
      case 'services':
        return Icons.handyman;
      case 'jobs':
        return Icons.work_outline;
      case 'animals':
        return Icons.pets;
      case 'music':
        return Icons.music_note;
      case 'food':
        return Icons.restaurant;
      default:
        return Icons.category_outlined;
    }
  }
}

// Expandable category tree widget for detailed filtering
class MarketplaceCategoryTree extends ConsumerWidget {
  final List<MarketplaceCategory> categories;
  final Set<int> selectedCategoryIds;
  final Function(Set<int>) onCategoriesSelected;
  final bool multiSelect;

  const MarketplaceCategoryTree({
    super.key,
    required this.categories,
    required this.selectedCategoryIds,
    required this.onCategoriesSelected,
    this.multiSelect = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topLevelCategories = categories
        .where((cat) => cat.parentId == null)
        .toList();

    return Column(
      children: topLevelCategories.map((category) {
        return _buildCategoryTreeItem(context, category);
      }).toList(),
    );
  }

  Widget _buildCategoryTreeItem(
    BuildContext context,
    MarketplaceCategory category,
  ) {
    final isSelected = selectedCategoryIds.contains(category.id);
    final hasChildren = category.children?.isNotEmpty == true;

    return ExpansionTile(
      leading: Icon(
        _getCategoryIcon(category.iconName),
        color: isSelected ? Theme.of(context).primaryColor : null,
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              category.name,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? Theme.of(context).primaryColor : null,
              ),
            ),
          ),
          if (category.count > 0)
            Chip(
              label: Text(
                '${category.count}',
                style: const TextStyle(fontSize: 12),
              ),
              backgroundColor: Colors.grey[200],
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
        ],
      ),
      onExpansionChanged: hasChildren
          ? null
          : (_) => _toggleCategory(category.id),
      children:
          category.children?.map((child) {
            return Padding(
              padding: const EdgeInsets.only(left: 20),
              child: _buildCategoryTreeItem(context, child),
            );
          }).toList() ??
          [],
    );
  }

  void _toggleCategory(int categoryId) {
    final newSelection = Set<int>.from(selectedCategoryIds);

    if (multiSelect) {
      if (newSelection.contains(categoryId)) {
        newSelection.remove(categoryId);
      } else {
        newSelection.add(categoryId);
      }
    } else {
      newSelection.clear();
      if (!selectedCategoryIds.contains(categoryId)) {
        newSelection.add(categoryId);
      }
    }

    onCategoriesSelected(newSelection);
  }

  IconData _getCategoryIcon(String? iconName) {
    // Same implementation as above
    switch (iconName?.toLowerCase()) {
      case 'electronics':
        return Icons.devices;
      case 'furniture':
        return Icons.chair_outlined;
      case 'clothing':
        return Icons.checkroom;
      case 'books':
        return Icons.book_outlined;
      case 'sports':
        return Icons.sports_soccer;
      case 'toys':
        return Icons.toys;
      case 'garden':
        return Icons.yard;
      case 'tools':
        return Icons.build;
      case 'vehicles':
        return Icons.directions_car;
      case 'home':
        return Icons.home_outlined;
      case 'services':
        return Icons.handyman;
      case 'jobs':
        return Icons.work_outline;
      case 'animals':
        return Icons.pets;
      case 'music':
        return Icons.music_note;
      case 'food':
        return Icons.restaurant;
      default:
        return Icons.category_outlined;
    }
  }
}
