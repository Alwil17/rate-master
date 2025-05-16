import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rate_master/providers/auth_provider.dart';
import 'package:rate_master/providers/item_provider.dart';
import 'package:rate_master/providers/rating_provider.dart';
import 'package:rate_master/screens/profile/widgets/stats_summary.dart';
import 'package:rate_master/screens/stats/widgets/category_pie_chart.dart';
import 'package:rate_master/screens/stats/widgets/rating_histogram.dart';
import 'package:rate_master/shared/constants/constants.dart';
import 'package:rate_master/shared/widgets/expanding_bottom_nav.dart';

class MyStatsScreen extends StatefulWidget {
  const MyStatsScreen({super.key});

  @override
  State<MyStatsScreen> createState() => _MyStatsScreenState();
}

class _MyStatsScreenState extends State<MyStatsScreen> {
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text("Mes stats"),
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
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                locale.summary,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 10),
              Consumer2<AuthProvider, RatingProvider>(
                builder: (ctx, auth, ratings, _) {
                  // Stats
                  final totalReviews = ratings.userReviews.length;
                  final reviewsWithComments = ratings.userReviews
                      .where((r) => r.comment!.trim().isNotEmpty)
                      .toList();
                  final commentCount = reviewsWithComments.length;
                  final avgRating = ratings.userReviews.isNotEmpty
                      ? ratings.userReviews
                              .map((r) => r.value)
                              .reduce((a, b) => a + b) /
                          ratings.userReviews.length
                      : 0.0;

                  return _buildChartWrapper(
                      StatsSummary(
                        reviewsCount: totalReviews,
                        averageRating: avgRating,
                        commentsCount: commentCount,
                      ),
                      Colors.white);
                },
              ),
              const SizedBox(height: 20),
              // 1. Distribution
              Text(
                locale.perRating,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 10),
              _buildChartWrapper(
                RatingHistogram(
                    ratings: Provider.of<RatingProvider>(context).userReviews),
                Colors.white,
              ),

              const SizedBox(height: 20),
              // 2. By categories
              Text(
                locale.perCategory,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 10),
              _buildChartWrapper(
                CategoryPieChart(
                    reviews: Provider.of<RatingProvider>(context).userReviews,
                    items: Provider.of<ItemProvider>(context).items),
                Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChartWrapper(Widget child, Color color) {
    return Card(
      elevation: 1,
      color: color,
      child: Padding(
        padding: EdgeInsets.all(8),
        child: child,
      ),
    );
  }
}
