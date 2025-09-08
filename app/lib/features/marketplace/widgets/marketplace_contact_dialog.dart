import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/marketplace_models.dart';

class MarketplaceContactDialog extends ConsumerStatefulWidget {
  final MarketplaceListing listing;

  const MarketplaceContactDialog({super.key, required this.listing});

  @override
  ConsumerState<MarketplaceContactDialog> createState() =>
      _MarketplaceContactDialogState();
}

class _MarketplaceContactDialogState
    extends ConsumerState<MarketplaceContactDialog> {
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Kontakt aufnehmen'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Interessiert an: ${widget.listing.title}'),
          const SizedBox(height: 16),
          TextField(
            controller: _messageController,
            decoration: const InputDecoration(
              labelText: 'Nachricht',
              hintText: 'Ihre Nachricht...',
              border: OutlineInputBorder(),
            ),
            maxLines: 4,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Abbrechen'),
        ),
        FilledButton(
          onPressed: () {
            // TODO: Implement contact functionality
            Navigator.of(context).pop();
          },
          child: const Text('Senden'),
        ),
      ],
    );
  }
}
