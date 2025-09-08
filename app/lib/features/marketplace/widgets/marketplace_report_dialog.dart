import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/marketplace_models.dart';
import '../repository/marketplace_repository.dart';

class MarketplaceReportDialog extends ConsumerStatefulWidget {
  final MarketplaceListing listing;

  const MarketplaceReportDialog({super.key, required this.listing});

  @override
  ConsumerState<MarketplaceReportDialog> createState() =>
      _MarketplaceReportDialogState();
}

class _MarketplaceReportDialogState
    extends ConsumerState<MarketplaceReportDialog> {
  ReportReason? _selectedReason;
  final TextEditingController _descriptionController = TextEditingController();
  bool _isSubmitting = false;

  final Map<ReportReason, String> _reasonLabels = {
    ReportReason.inappropriate: 'Unangemessener Inhalt',
    ReportReason.spam: 'Spam oder Werbung',
    ReportReason.fraud: 'Betrug oder Täuschung',
    ReportReason.duplicate: 'Doppelt eingereicht',
    ReportReason.other: 'Sonstiges',
  };

  final Map<ReportReason, String> _reasonDescriptions = {
    ReportReason.inappropriate:
        'Anstößige, beleidigende oder unpassende Inhalte',
    ReportReason.spam: 'Unerwünschte Werbung oder wiederholte Nachrichten',
    ReportReason.fraud:
        'Betrügerische Absichten oder irreführende Informationen',
    ReportReason.duplicate:
        'Diese Anzeige wurde bereits mehrfach veröffentlicht',
    ReportReason.other: 'Ein anderes Problem, das nicht aufgeführt ist',
  };

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Anzeige melden'),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Warum möchten Sie diese Anzeige melden?',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),

            // Reason Selection
            ..._reasonLabels.entries.map((entry) {
              return RadioListTile<ReportReason>(
                title: Text(entry.value),
                subtitle: Text(
                  _reasonDescriptions[entry.key] ?? '',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                ),
                value: entry.key,
                groupValue: _selectedReason,
                onChanged: (reason) {
                  setState(() {
                    _selectedReason = reason;
                  });
                },
                contentPadding: EdgeInsets.zero,
              );
            }),

            const SizedBox(height: 16),

            // Description Field
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Zusätzliche Details (optional)',
                hintText: 'Beschreiben Sie das Problem genauer...',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              maxLines: 3,
              maxLength: 500,
            ),

            const SizedBox(height: 8),

            // Privacy Notice
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline, color: Colors.blue[700], size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Ihre Meldung wird vertraulich behandelt. Wir prüfen alle Meldungen und nehmen entsprechende Maßnahmen vor.',
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.blue[700]),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
          child: const Text('Abbrechen'),
        ),
        ElevatedButton(
          onPressed: _canSubmit() && !_isSubmitting ? _submitReport : null,
          child: _isSubmitting
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Melden'),
        ),
      ],
    );
  }

  bool _canSubmit() {
    return _selectedReason != null;
  }

  void _submitReport() async {
    if (!_canSubmit() || _isSubmitting) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      final report = MarketplaceReport(
        listingId: widget.listing.id,
        reason: _selectedReason!,
        description: _descriptionController.text.trim(),
      );

      await ref.read(marketplaceRepositoryProvider).reportListing(report);

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Meldung erfolgreich gesendet. Vielen Dank!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fehler beim Senden der Meldung: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }
}
