import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:rate_master/models/item.dart';
import 'package:rate_master/providers/item_provider.dart';
import 'package:rate_master/screens/items/widgets/item_detail_header.dart';
import 'package:rate_master/shared/theme/theme.dart';

class ItemDetailScreen extends StatefulWidget {
  final num itemId;

  const ItemDetailScreen({
    Key? key,
    required this.itemId,
  }) : super(key: key);

  @override
  _ItemDetailScreenState createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  late final ItemProvider _itemProvider;

  @override
  void initState() {
    super.initState();
    _itemProvider = Provider.of<ItemProvider>(context, listen: false);
    // Schedule fetch AFTER first frame:
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _itemProvider.fetchItem(widget.itemId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    return Consumer<ItemProvider>(
      builder: (context, provider, _) {
        // 1. Loading
        if (provider.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // 2. Erreur
        if (provider.error != null) {
          return Scaffold(
            body: Center(
              child: Text(
                provider.error!,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          );
        }

        // 3. Pas d'item trouvé
        final item = provider.currentItem;
        if (item == null) {
          return Scaffold(
            body: Center(child: Text(locale.itemNotFound)),
          );
        }

        // 4. Affichage normal
        return Scaffold(
          body: Column(
            children: [
              ItemDetailHeader(item: item),
              // TODO: ajouter ItemDetailBody(item: item)
            ],
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.star, color: Colors.white),
              label: Text(
                locale.rateNow,
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () {},
            ),
          ),
        );
      },
    );
  }
}
