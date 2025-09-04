import 'package:flutter/material.dart';

import '../../domain/document.dart';

class CategoryFilterChip extends StatelessWidget {
  final DocumentCategory category;
  final bool isSelected;
  final ValueChanged<bool> onSelected;

  const CategoryFilterChip({
    super.key,
    required this.category,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(_getCategoryDisplayName(category)),
      avatar: isSelected
          ? const Icon(Icons.check, size: 16)
          : Icon(_getCategoryIcon(category), size: 16),
      selected: isSelected,
      onSelected: onSelected,
      backgroundColor: isSelected 
          ? _getCategoryColor(category).withOpacity(0.1)
          : null,
      selectedColor: _getCategoryColor(category).withOpacity(0.2),
      checkmarkColor: _getCategoryColor(category),
      side: isSelected
          ? BorderSide(color: _getCategoryColor(category))
          : null,
    );
  }

  String _getCategoryDisplayName(DocumentCategory category) {
    switch (category) {
      case DocumentCategory.applications:
        return 'Anträge';
      case DocumentCategory.permits:
        return 'Genehmigungen';
      case DocumentCategory.taxes:
        return 'Steuern';
      case DocumentCategory.socialServices:
        return 'Soziales';
      case DocumentCategory.civilRegistry:
        return 'Bürgeramt';
      case DocumentCategory.planning:
        return 'Planung';
      case DocumentCategory.announcements:
        return 'Bekanntmachung';
      case DocumentCategory.regulations:
        return 'Satzungen';
      case DocumentCategory.emergency:
        return 'Notfall';
      case DocumentCategory.other:
        return 'Sonstige';
    }
  }

  IconData _getCategoryIcon(DocumentCategory category) {
    switch (category) {
      case DocumentCategory.applications:
        return Icons.description;
      case DocumentCategory.permits:
        return Icons.verified;
      case DocumentCategory.taxes:
        return Icons.account_balance;
      case DocumentCategory.socialServices:
        return Icons.people;
      case DocumentCategory.civilRegistry:
        return Icons.how_to_reg;
      case DocumentCategory.planning:
        return Icons.architecture;
      case DocumentCategory.announcements:
        return Icons.campaign;
      case DocumentCategory.regulations:
        return Icons.gavel;
      case DocumentCategory.emergency:
        return Icons.emergency;
      case DocumentCategory.other:
        return Icons.folder;
    }
  }

  Color _getCategoryColor(DocumentCategory category) {
    switch (category) {
      case DocumentCategory.applications:
        return Colors.blue;
      case DocumentCategory.permits:
        return Colors.purple;
      case DocumentCategory.taxes:
        return Colors.green;
      case DocumentCategory.socialServices:
        return Colors.orange;
      case DocumentCategory.civilRegistry:
        return Colors.teal;
      case DocumentCategory.planning:
        return Colors.indigo;
      case DocumentCategory.announcements:
        return Colors.red;
      case DocumentCategory.regulations:
        return Colors.brown;
      case DocumentCategory.emergency:
        return Colors.red[700]!;
      case DocumentCategory.other:
        return Colors.grey;
    }
  }
}
