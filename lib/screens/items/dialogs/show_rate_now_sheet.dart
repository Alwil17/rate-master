import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rate_master/shared/theme/theme.dart';

/// Displays the “Rate Now” sheet.
/// Call this from your “Noter maintenant” button’s onPressed.
void showRateNowSheet(
  BuildContext context, {
  required Function(double rating, String comment) onSubmit,
}) {
  double selectedRating = 0;
  final commentCtrl = TextEditingController();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    backgroundColor: Colors.white,
    builder: (ctx) => Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(ctx).viewInsets.bottom,
        top: 24,
        left: 24,
        right: 24,
      ),
      child: StatefulBuilder(
        builder: (context, setModalState) {
          // compute full/half stars each build
          int fullStars = selectedRating.floor();

          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  AppLocalizations.of(context)!.rateNow,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 16),

              // Star picker row using your logic
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    onPressed: () {
                      setModalState(() {
                        selectedRating = index + 1.0;
                      });
                    },
                    icon: () {
                      if (index < fullStars) {
                        // full star
                        return const PhosphorIcon(
                          PhosphorIconsDuotone.star,
                          size: 32,
                          color: Colors.amber,
                        );
                      } else {
                        // empty star
                        return PhosphorIcon(
                          PhosphorIconsFill.star,
                          size: 32,
                          color: Colors.grey[300],
                        );
                      }
                    }(),
                  );
                }),
              ),

              const SizedBox(height: 16),
              TextField(
                controller: commentCtrl,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.leaveAComment,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: Text(AppLocalizations.of(context)!.cancel),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      onSubmit(selectedRating, commentCtrl.text.trim());
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent),
                    child: Text(
                      AppLocalizations.of(context)!.rate,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          );
        },
      ),
    ),
  );
}
