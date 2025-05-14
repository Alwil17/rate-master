import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:rate_master/providers/item_provider.dart';
import 'package:rate_master/providers/rating_provider.dart';
import 'package:rate_master/shared/widgets/item_card/item_card_horizontal.dart';

Widget buildRecentlyRated(BuildContext context) {
  final locale = AppLocalizations.of(context)!;
  return Consumer2<ItemProvider, RatingProvider>(
    builder: (context, itemProvider, ratingProvider, _) {
      if (ratingProvider.isLoadingReviews) {
        // Loader centré
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      if (ratingProvider.error != null) {
        // Message d'erreur
        return Center(
          child: Text(
            ratingProvider.error!,
            style: const TextStyle(color: Colors.red),
          ),
        );
      }

      if (ratingProvider.userReviews.isEmpty || itemProvider.items.isEmpty) {
        // Aucun item trouvé
        return Center(
          child: Text(locale.noItemFound),
        );
      }

      final validRatings = ratingProvider.userReviews
          .where((r) => itemProvider.items.any((i) => i.id == r.itemId))
          .toList();

      // Affiche la liste horizontale
      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemCount: ratingProvider.userReviews
            .where((r) => itemProvider.items.any((i) => i.id == r.itemId))
            .length,
        itemBuilder: (context, index) {
          final rating = validRatings[index];
          final item = itemProvider.items.firstWhere((i) => i.id == rating.itemId);
          return ItemCardHorizontal(item: item);
        },
      );
    },
  );
}