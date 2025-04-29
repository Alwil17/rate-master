import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

/// Displays the “Rate Now” sheet.
/// Call this from your “Noter maintenant” button’s onPressed.
void showRateNowSheet(BuildContext context, {
  required Function(double rating, String comment) onSubmit,
}) {
  double _selectedRating = 0;
  final TextEditingController _commentCtrl = TextEditingController();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true, // allow full height if keyboard pops
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (ctx) {
      return Padding(
        // ensures sheet moves above keyboard
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom,
          top: 24,
          left: 24,
          right: 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Center(
              child: Text(
                'Rate Now',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(ctx).primaryColor,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Star rating picker
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (i) {
                final idx = i + 1;
                return IconButton(
                  // English-only comments from here on
                  onPressed: () {
                    _selectedRating = idx.toDouble();
                    // Trigger rebuild by calling setState on the sheet's StatefulBuilder
                    (ctx as Element).markNeedsBuild();
                  },
                  icon: Icon(
                    _selectedRating >= idx
                        ? PhosphorIconsDuotone.star
                        : PhosphorIconsDuotone.starHalf,
                    size: 32,
                    color: Colors.amber,
                  ),
                );
              }),
            ),
            const SizedBox(height: 16),

            // Optional user comment
            TextField(
              controller: _commentCtrl,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Leave a comment (optional)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    onSubmit(_selectedRating, _commentCtrl.text.trim());
                  },
                  child: const Text('Submit'),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      );
    },
  );
}
