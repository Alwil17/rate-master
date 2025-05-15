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

import 'dialogs/show_delete_review_dialog.dart';

class ItemDetailScreen extends StatefulWidget {
  final num itemId;

  const ItemDetailScreen({
    super.key,
    required this.itemId,
  });

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

  void fetchItemDatas() {
    _itemProvider.fetchItem(widget.itemId);
    _ratingProvider.fetchItemReviews(widget.itemId);
    _ratingProvider.fetchUserReviewForItem(widget.itemId);
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;

    return Consumer2<ItemProvider, RatingProvider>(
      builder: (context, itemProvider, ratingProvider, _) {
        // Loading
        if (itemProvider.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Error
        if (itemProvider.error != null) {
          return Scaffold(
            body: Center(
              child: Text(
                itemProvider.error!,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          );
        }

        final item = itemProvider.currentItem;
        if (item == null) {
          return Scaffold(
            body: Center(child: Text(locale.itemNotFound)),
          );
        }

        return Scaffold(
          body: Column(
            children: [
              ItemDetailHeader(item: item),
              Expanded(child: ItemDetailBody(item: item)),
            ],
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ratingProvider.currentRating != null
                ? _buildEditOrDeleteButtons(item)
                : _buildRateNowButton(item),
          ),
        );
      },
    );
  }

  Widget _buildRateNowButton(Item item) {
    final locale = AppLocalizations.of(context)!;
    return ElevatedButton.icon(
      icon: const Icon(Icons.star, color: Colors.white),
      label: Text(
        locale.rateNow,
        style: const TextStyle(color: Colors.white),
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

  Widget _buildEditOrDeleteButtons(Item item) {
    final locale = AppLocalizations.of(context)!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        /// Edit button
        Expanded(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.edit, color: Colors.white),
            label: Text(
              locale.editMyReview,
              style: const TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            onPressed: () async {
              FocusScope.of(context).requestFocus(FocusNode());
              final success = await showRateNowSheet(context,
                  itemId: item.id,
                  userId: _authProvider.user!.id,
                  existingRating: _ratingProvider.currentRating);
              if (success) fetchItemDatas();
            },
          ),
        ),
        const SizedBox(width: 12),

        /// Delete button
        Expanded(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.delete, color: Colors.red),
            label: Text(locale.deleteMyReview,
                style: const TextStyle(color: Colors.red)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey.shade100,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            onPressed: () async {
              showDeleteReviewDialog(
                context: context,
                ratingProvider: _ratingProvider,
                itemId: item.id,
                onSuccess: () => _ratingProvider.fetchMyReviews(_authProvider.user!.id),
              );
            },
          ),
        ),
      ],
    );
  }
}
