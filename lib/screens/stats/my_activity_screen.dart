import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:rate_master/shared/constants/constants.dart';
import 'package:rate_master/shared/widgets/expanding_bottom_nav.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'my_reviews_screen.dart';
import 'my_stats_screen.dart';

class MyActivityScreen extends StatelessWidget {
  const MyActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.myActivity),
          centerTitle: true,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const PhosphorIcon(PhosphorIconsRegular.arrowLeft,
                color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          bottom: TabBar(
            labelColor: Colors.black,
            indicatorColor: Colors.blue,
            tabs: [
              Tab(text: AppLocalizations.of(context)!.myReviews),
              Tab(text: AppLocalizations.of(context)!.myStats),
            ],
          ),
        ),
        bottomNavigationBar: ExpandingBottomNav(items: Constants.navItems),
        body: const TabBarView(
          children: [
            MyReviewsScreen(),
            MyStatsScreen(),
          ],
        ),
      ),
    );
  }
}
