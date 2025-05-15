import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rate_master/models/item.dart';
import 'package:rate_master/models/rating.dart';
import 'package:rate_master/providers/item_provider.dart';
import 'package:rate_master/providers/rating_provider.dart';
import 'package:rate_master/shared/constants/constants.dart';
import 'package:rate_master/shared/widgets/average_rating_display.dart';
import 'package:rate_master/shared/widgets/expanding_bottom_nav.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyReviewsScreen extends StatefulWidget {
  const MyReviewsScreen({super.key});

  @override
  State<MyReviewsScreen> createState() => _MyReviewsScreenState();
}

class _MyReviewsScreenState extends State<MyReviewsScreen> {
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text("Mes avis"),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const PhosphorIcon(PhosphorIconsRegular.arrowLeft,
              color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      bottomNavigationBar: ExpandingBottomNav(items: Constants.navItems),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: Consumer2<RatingProvider, ItemProvider>(
          builder: (context, ratingProvider, itemProvider, _) {
            if (ratingProvider.isLoadingReviews) {
              return const Center(child: CircularProgressIndicator());
            }
            if (ratingProvider.error != null) {
              // Error message
              return Center(
                  child: Text(ratingProvider.error!,
                      style: const TextStyle(color: Colors.red)));
            }

            if (ratingProvider.userReviews.isEmpty ||
                itemProvider.items.isEmpty) {
              // No item found
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
              separatorBuilder: (_, __) => const SizedBox(height: 5),
              itemCount: validRatings.length,
              itemBuilder: (context, index) {
                final rating = validRatings[index];
                final item =
                    itemProvider.items.firstWhere((i) => i.id == rating.itemId);
                return _buildReviewTile(rating, item);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildReviewTile(Rating review, Item item) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 1,
      color: Colors.white,
      shape: const RoundedRectangleBorder(
        side: BorderSide(
          color: Colors.grey,
          width: 0.3,
        ),
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: ListTile(
        title: Text(
          item.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            AverageRatingDisplay(
              averageRating: review.value,
              totalReviews: 0, // show only stars for this single review
            ),
            if (review.comment != null && review.comment!.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                review.comment!,
                style: const TextStyle(fontStyle: FontStyle.italic),
              ),
            ],
            const SizedBox(height: 6),
            Text(
              DateFormat.yMMMd().format(review.createdAt!),
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'edit') {
              // TODO: open edit form
            } else if (value == 'delete') {
              // TODO: confirm and delete
            }
          },
          itemBuilder: (context) => const [
            PopupMenuItem(value: 'edit', child: Text('Modifier')),
            PopupMenuItem(value: 'delete', child: Text('Supprimer')),
          ],
        ),
      ),
    );
  }
}
