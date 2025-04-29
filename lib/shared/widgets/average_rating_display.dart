import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class AverageRatingDisplay extends StatelessWidget {
  final double averageRating; // e.g. 4.3
  final int totalReviews;     // e.g. 128

  const AverageRatingDisplay({
    Key? key,
    required this.averageRating,
    required this.totalReviews,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int fullStars = averageRating.floor();
    bool hasHalfStar = (averageRating - fullStars) >= 0.5;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Star icons
        Row(
          children: List.generate(5, (index) {
            if (index < fullStars) {
              // full star
              return const PhosphorIcon(PhosphorIconsDuotone.star, size: 20, color: Colors.amber);
            } else if (index == fullStars && hasHalfStar) {
              // half star
              return const PhosphorIcon(PhosphorIconsDuotone.starHalf, color: Colors.amber, size: 20);
            } else {
              // empty star
              return PhosphorIcon(PhosphorIconsFill.star, color: Colors.grey[300], size: 20);
            }
          }),
        ),
        const SizedBox(width: 8),
        // Text rating (e.g. "4.3 (128)")
        Text(
          "$averageRating ($totalReviews)",
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
