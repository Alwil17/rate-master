import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:rate_master/models/item.dart';
import 'package:rate_master/providers/auth_provider.dart';
import 'package:rate_master/providers/item_provider.dart';
import 'package:rate_master/providers/rating_provider.dart';
import 'package:rate_master/screens/items/dialogs/show_rate_now_sheet.dart';
import 'package:rate_master/screens/items/widgets/item_detail_body.dart';
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
  late final AuthProvider _authProvider;
  late final ItemProvider _itemProvider;
  late final RatingProvider _ratingProvider;

  @override
  void initState() {
    super.initState();
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
    _itemProvider = Provider.of<ItemProvider>(context, listen: false);
    _ratingProvider = Provider.of<RatingProvider>(context, listen: false);
    // Schedule fetch AFTER first frame:
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchItemDatas();
    });
  }

  void fetchItemDatas(){
    _itemProvider.fetchItem(widget.itemId);
    _ratingProvider.fetchItemReviews(widget.itemId);
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
              Expanded(
                child: ItemDetailBody(item: provider.currentItem!),
              ),
            ],
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildRateNowButton(item),
          ),
        );
      },
    );
  }

  Widget _buildRateNowButton(Item item){
    final locale = AppLocalizations.of(context)!;
    return ElevatedButton.icon(
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
      onPressed: () async {
        final success = await showRateNowSheet(
          context,
          itemId: item.id,
          userId: _authProvider.user!.id,
        );
        if (success) fetchItemDatas();
      },
    );
  }
}
