import 'package:flutter/material.dart';

class MarketplaceSortDropdown extends StatelessWidget {
  final String currentSort;
  final String currentOrder;
  final Function(String sort, String order) onChanged;

  const MarketplaceSortDropdown({
    super.key,
    required this.currentSort,
    required this.currentOrder,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.sort),
      onSelected: (value) {
        switch (value) {
          case 'created_at_desc':
            onChanged('created_at', 'desc');
            break;
          case 'created_at_asc':
            onChanged('created_at', 'asc');
            break;
          case 'price_asc':
            onChanged('price', 'asc');
            break;
          case 'price_desc':
            onChanged('price', 'desc');
            break;
          case 'title_asc':
            onChanged('title', 'asc');
            break;
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'created_at_desc',
          child: Row(
            children: [
              Icon(Icons.schedule),
              SizedBox(width: 8),
              Text('Neueste zuerst'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'created_at_asc',
          child: Row(
            children: [
              Icon(Icons.history),
              SizedBox(width: 8),
              Text('Älteste zuerst'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'price_asc',
          child: Row(
            children: [
              Icon(Icons.arrow_upward),
              SizedBox(width: 8),
              Text('Preis aufsteigend'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'price_desc',
          child: Row(
            children: [
              Icon(Icons.arrow_downward),
              SizedBox(width: 8),
              Text('Preis absteigend'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'title_asc',
          child: Row(
            children: [
              Icon(Icons.sort_by_alpha),
              SizedBox(width: 8),
              Text('Alphabetisch'),
            ],
          ),
        ),
      ],
    );
  }
}
