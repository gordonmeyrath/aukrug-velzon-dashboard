import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/marketplace_models.dart';
import '../providers/marketplace_providers.dart';

class MarketplaceCategorySelector extends ConsumerWidget {
  final MarketplaceCategory? selectedCategory;
  final Function(MarketplaceCategory?) onCategoryChanged;
  final bool isRequired;
  final String? errorText;

  const MarketplaceCategorySelector({
    super.key,
    required this.selectedCategory,
    required this.onCategoryChanged,
    this.isRequired = false,
    this.errorText,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(marketplaceCategoriesProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Kategorie${isRequired ? ' *' : ''}',
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),

        categoriesAsync.when(
          data: (categories) => _buildCategorySelector(context, categories),
          loading: () => _buildLoadingState(context),
          error: (error, stack) => _buildErrorState(context, error),
        ),

        if (errorText != null) ...[
          const SizedBox(height: 4),
          Text(
            errorText!,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildCategorySelector(
    BuildContext context,
    List<MarketplaceCategory> categories,
  ) {
    // Group categories by parent
    final topLevelCategories = categories
        .where((c) => c.parentId == null)
        .toList();
    final categoryMap = <int, List<MarketplaceCategory>>{};

    for (final category in categories) {
      if (category.parentId != null) {
        categoryMap.putIfAbsent(category.parentId!, () => []).add(category);
      }
    }

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: errorText != null
              ? Theme.of(context).colorScheme.error
              : Colors.grey[300]!,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ExpansionTile(
        title: Text(
          selectedCategory?.name ?? 'Kategorie auswählen',
          style: TextStyle(
            color: selectedCategory != null
                ? Theme.of(context).textTheme.bodyLarge?.color
                : Colors.grey[600],
          ),
        ),
        trailing: Icon(Icons.keyboard_arrow_down, color: Colors.grey[600]),
        children: [
          Container(
            constraints: const BoxConstraints(maxHeight: 300),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // "Keine Kategorie" Option
                  if (!isRequired)
                    ListTile(
                      dense: true,
                      title: const Text('Keine Kategorie'),
                      leading: Radio<MarketplaceCategory?>(
                        value: null,
                        groupValue: selectedCategory,
                        onChanged: (value) => onCategoryChanged(null),
                      ),
                      onTap: () => onCategoryChanged(null),
                    ),

                  // Category tree
                  ...topLevelCategories.map((parentCategory) {
                    final subcategories = categoryMap[parentCategory.id] ?? [];

                    return Column(
                      children: [
                        // Parent category
                        ListTile(
                          dense: true,
                          title: Text(
                            parentCategory.name,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          subtitle: parentCategory.description != null
                              ? Text(
                                  parentCategory.description!,
                                  style: Theme.of(context).textTheme.bodySmall,
                                )
                              : null,
                          leading: Radio<MarketplaceCategory>(
                            value: parentCategory,
                            groupValue: selectedCategory,
                            onChanged: (value) => onCategoryChanged(value),
                          ),
                          trailing: subcategories.isNotEmpty
                              ? Icon(
                                  Icons.chevron_right,
                                  color: Colors.grey[400],
                                )
                              : null,
                          onTap: () => onCategoryChanged(parentCategory),
                        ),

                        // Subcategories
                        ...subcategories.map((subcategory) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 32),
                            child: ListTile(
                              dense: true,
                              title: Text(subcategory.name),
                              subtitle: subcategory.description != null
                                  ? Text(
                                      subcategory.description!,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodySmall,
                                    )
                                  : null,
                              leading: Radio<MarketplaceCategory>(
                                value: subcategory,
                                groupValue: selectedCategory,
                                onChanged: (value) => onCategoryChanged(value),
                              ),
                              onTap: () => onCategoryChanged(subcategory),
                            ),
                          );
                        }),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, Object error) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.error),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: Theme.of(context).colorScheme.error,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'Fehler beim Laden der Kategorien',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ],
        ),
      ),
    );
  }
}

class MarketplaceCategoryChip extends StatelessWidget {
  final MarketplaceCategory category;
  final bool isSelected;
  final VoidCallback? onTap;
  final bool showCount;
  final int? count;

  const MarketplaceCategoryChip({
    super.key,
    required this.category,
    this.isSelected = false,
    this.onTap,
    this.showCount = false,
    this.count,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(category.name),
          if (showCount && count != null) ...[
            const SizedBox(width: 4),
            Text(
              '($count)',
              style: TextStyle(
                fontSize: 12,
                color: isSelected
                    ? Colors.white.withOpacity(0.8)
                    : Colors.grey[600],
              ),
            ),
          ],
        ],
      ),
      selected: isSelected,
      onSelected: onTap != null ? (_) => onTap!() : null,
      backgroundColor: Colors.grey[100],
      selectedColor: Theme.of(context).primaryColor,
      checkmarkColor: Colors.white,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.black87,
        fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
      ),
      side: BorderSide(
        color: isSelected ? Theme.of(context).primaryColor : Colors.grey[300]!,
      ),
    );
  }
}

class MarketplaceCategoryBreadcrumb extends StatelessWidget {
  final MarketplaceCategory category;
  final Function(MarketplaceCategory)? onCategoryTap;

  const MarketplaceCategoryBreadcrumb({
    super.key,
    required this.category,
    this.onCategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    // Build breadcrumb path (this would need parent category resolution)
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.folder_outlined,
            size: 16,
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onCategoryTap != null
                ? () => onCategoryTap!(category)
                : null,
            child: Text(
              category.name,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Horizontal category filter for list screens
class MarketplaceCategoryFilter extends ConsumerWidget {
  final MarketplaceCategory? selectedCategory;
  final Function(MarketplaceCategory?) onCategoryChanged;
  final bool showCounts;

  const MarketplaceCategoryFilter({
    super.key,
    required this.selectedCategory,
    required this.onCategoryChanged,
    this.showCounts = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(marketplaceCategoriesProvider);

    return categoriesAsync.when(
      data: (categories) => _buildCategoryFilter(context, categories),
      loading: () => _buildLoadingFilter(context),
      error: (error, stack) => const SizedBox.shrink(),
    );
  }

  Widget _buildCategoryFilter(
    BuildContext context,
    List<MarketplaceCategory> categories,
  ) {
    final topLevelCategories = categories
        .where((c) => c.parentId == null)
        .toList();

    if (topLevelCategories.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: topLevelCategories.length + 1, // +1 for "Alle"
        itemBuilder: (context, index) {
          if (index == 0) {
            // "Alle" chip
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: const Text('Alle'),
                selected: selectedCategory == null,
                onSelected: (_) => onCategoryChanged(null),
                backgroundColor: Colors.grey[100],
                selectedColor: Theme.of(context).primaryColor,
                checkmarkColor: Colors.white,
                labelStyle: TextStyle(
                  color: selectedCategory == null
                      ? Colors.white
                      : Colors.black87,
                  fontWeight: selectedCategory == null
                      ? FontWeight.w500
                      : FontWeight.normal,
                ),
              ),
            );
          }

          final category = topLevelCategories[index - 1];
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: MarketplaceCategoryChip(
              category: category,
              isSelected: selectedCategory?.id == category.id,
              onTap: () => onCategoryChanged(
                selectedCategory?.id == category.id ? null : category,
              ),
              showCount: showCounts,
              // Count would need to be fetched from repository
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoadingFilter(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: 5,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Container(
              width: 80,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          );
        },
      ),
    );
  }
}
