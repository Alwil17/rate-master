import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:rate_master/models/rating.dart';
import 'package:rate_master/providers/rating_provider.dart';
import 'package:rate_master/shared/theme/theme.dart';
import 'package:rate_master/shared/widgets/utils.dart';

/// Displays the “Rate Now” sheet.
/// Call this from your “Noter maintenant” button’s onPressed.
/// Returns true if the user submitted, false if cancelled.
Future<bool> showRateNowSheet(BuildContext context, {
  required int itemId,
  required int userId,
  Rating? existingRating,
}) {
  double selectedRating = existingRating?.value.toDouble() ?? 0;
  final commentCtrl = TextEditingController(text: existingRating?.comment ?? "");

  return showModalBottomSheet<bool>(
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
                    onPressed: () => Navigator.of(ctx).pop(false),
                    child: Text(AppLocalizations.of(context)!.cancel),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () async {
                      FocusScope.of(context).requestFocus(FocusNode());
                      await EasyLoading.show(status: "loading...");
                      final rating = Rating(
                        id: existingRating?.id,
                        value: selectedRating,
                        comment: commentCtrl.text.trim(),
                        userId: userId,
                        itemId: itemId,
                      );
                      final provider =
                          Provider.of<RatingProvider>(context, listen: false);
                      final success = await provider.submitRating(rating);
                      if (!success && provider.error != null) {
                        Utils.showError(context, provider.error!);
                      }
                      await EasyLoading.dismiss();
                      Navigator.of(ctx).pop(true);
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
  ).then((value) => value ?? false);
}
