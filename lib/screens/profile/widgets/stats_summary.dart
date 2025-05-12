import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'stat_item.dart';

/// A summary row displaying three statistics with separators.
class StatsSummary extends StatelessWidget {
  /// Number of reviews.
  final int reviewsCount;

  /// Average rating.
  final double averageRating;

  /// Number of comments.
  final int commentsCount;

  const StatsSummary({
    Key? key,
    required this.reviewsCount,
    required this.averageRating,
    required this.commentsCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: StatItem(
              value: reviewsCount.toString(),
              label: locale.reviews,
            ),
          ),
          const VerticalDivider(
            width: 5,
            thickness: 1,
            color: Colors.grey,
          ),
          Expanded(
            child: StatItem(
              value: averageRating.toStringAsFixed(1),
              label: locale.rateAverage,
            ),
          ),
          const VerticalDivider(
            width: 5,
            thickness: 1,
            color: Colors.grey,
          ),
          Expanded(
            child: StatItem(
              value: commentsCount.toString(),
              label: locale.comments,
            ),
          ),
        ],
      ),
    );
  }
}
