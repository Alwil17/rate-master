import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:rate_master/providers/item_provider.dart';
import 'package:rate_master/shared/widgets/item_card/item_card_vertical.dart';

Widget buildRecommandedList(BuildContext context) {
  final locale = AppLocalizations.of(context)!;
  return Consumer<ItemProvider>(
    builder: (context, provider, _) {
      if (provider.isLoading) {
        // Loader centré
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      if (provider.error != null) {
        // Message d'erreur
        return Center(
          child: Text(
            provider.error!,
            style: const TextStyle(color: Colors.red),
          ),
        );
      }

      if (provider.recommandations.isEmpty) {
        // Aucun item trouvé
        return Center(
          child: Text(locale.noItemFound),
        );
      }

      // Affiche la liste horizontale
      return ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: provider.recommandations.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final item = provider.recommandations[index];
          return ItemCardVertical(item: item);
        },
      );
    },
  );
}