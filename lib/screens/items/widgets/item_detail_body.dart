import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rate_master/models/item.dart';
import 'package:rate_master/models/rating.dart';
import 'package:rate_master/providers/rating_provider.dart';
import 'package:rate_master/shared/theme/theme.dart';
import 'package:rate_master/shared/widgets/average_rating_display.dart';
import 'package:rate_master/shared/widgets/chips/category_chip.dart';
import 'package:rate_master/shared/widgets/chips/tag_chip.dart';

class ItemDetailBody extends StatefulWidget {
  final Item item;

  const ItemDetailBody({Key? key, required this.item}) : super(key: key);

  @override
  _ItemDetailBodyState createState() => _ItemDetailBodyState();
}

class _ItemDetailBodyState extends State<ItemDetailBody>
    with SingleTickerProviderStateMixin {
  int _currentPage = 0; // Current page index
  late PageController _pageController; // PageView controller

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    return Column(
      children: [
        // Navigation buttons for pages
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavButton(locale.about, 0),
              _buildNavButton(locale.reviews, 1),
            ],
          ),
        ),

        // PageView that fills remaining height
        Expanded(
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) => setState(() => _currentPage = index),
            children: [
              // ABOUT page: scrollable content
              SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Categories & tags as chips
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (var category in widget.item.categories)
                          CategoryChip(label: category.name),
                        for (var tag in widget.item.tags)
                          TagChip(label: tag.name),
                      ],
                    ),
                    const SizedBox(height: 10),
                    AverageRatingDisplay(
                      averageRating: widget.item.avgRating,
                      totalReviews: widget.item.countRating,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      locale.description,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff056380),
                      ),
                    ),
                    const SizedBox(height: 5),
                    // Detailed description
                    Text(
                      widget.item.description ?? '',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),

                    // Add more content here if needed...
                    const SizedBox(height: 200), // demo extra space
                  ],
                ),
              ),

              // REVIEWS page: scrollable placeholder
              // Inside your PageView’s second child:
              SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1) Header with average + total
                    Text(
                      'Reviews (${widget.item.countRating})',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    AverageRatingDisplay(
                      averageRating: widget.item.avgRating,
                      totalReviews: widget.item.countRating,
                    ),

                    const SizedBox(height: 24),

                    // 3) List of reviews
                    Consumer<RatingProvider>(
                      builder: (ctx, rp, _) {
                        if (rp.isLoadingReviews) {
                          return Center(child: CircularProgressIndicator());
                        } else if (rp.error != null) {
                          return Center(child: Text(rp.error!));
                        } else if (rp.reviews.isEmpty) {
                          return Center(child: Text(locale.noReviewsYet));
                        }

                        return ListView.separated(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: rp.reviews.length,
                          separatorBuilder: (_, __) => Divider(),
                          itemBuilder: (ctx, i) => _buildReviewTile(rp.reviews[i]),
                        );
                      },
                    ),
                  ],
                ),
              ),

              /*SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                child: Center(
                  child: Text(
                    locale.reviewsInProgress, // e.g. "Reviews section under construction"
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ),*/
            ],
          ),
        ),
      ],
    );
  }

  /// Builds one of the two nav buttons and updates the PageView on tap
  Widget _buildNavButton(String label, int pageIndex) {
    return ElevatedButton(
      onPressed: () {
        _pageController.animateToPage(
          pageIndex,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
      style: ElevatedButton.styleFrom(
        fixedSize: const Size(145, 36),
        backgroundColor:
        _currentPage == pageIndex ? AppColors.accent : Colors.grey[300],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: _currentPage == pageIndex
              ? Colors.white
              : AppColors.secondaryBackground,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  /// Builds single review tile
  Widget _buildReviewTile(Rating review) {
    return ListTile(
      // optional: CircleAvatar(child: Text(review.userInitials))
      title: AverageRatingDisplay(
        averageRating: review.value,
        totalReviews: 0, // show only stars for this single review
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (review.comment != null && review.comment!.isNotEmpty)
            Text(review.comment!),
          const SizedBox(height: 4),
          Text(
            DateFormat.yMMMd().format(review.createdAt!),
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }

}
