import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rate_master/providers/rating_provider.dart';

Future<void> showDeleteReviewDialog({
  required BuildContext context,
  required RatingProvider ratingProvider,
  required int itemId,
  required VoidCallback onSuccess,
}) async {
  final locale = AppLocalizations.of(context)!;

  // 1) show confirmation dialog
  final confirm = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(locale.confirmDeleteTitle),
      content: Text(locale.confirmDeleteMessage),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: Text(locale.cancel),
        ),
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(true),
          child: Text(locale.delete),
        ),
      ],
    ),
  );

  if (confirm == true) {
    // 2) delete from provider
    final success = await ratingProvider.deleteReviewForItem(itemId);

    if (context.mounted) {
      final messenger = ScaffoldMessenger.of(context);
      if (success) {
        messenger.showSnackBar(SnackBar(content: Text(locale.deleteSuccess)));
        onSuccess(); // Callback to refresh data
      } else {
        messenger.showSnackBar(SnackBar(
          content: Text(ratingProvider.error ?? locale.deleteError),
        ));
      }
    }
  }
}
