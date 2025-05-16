import 'package:flutter/material.dart';

import 'my_reviews_screen.dart';
import 'my_stats_screen.dart';

class MyActivityScreen extends StatelessWidget {
  const MyActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Nombre d'onglets
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Mon activité'),
          centerTitle: true,
          backgroundColor: Colors.white,
          bottom: const TabBar(
            labelColor: Colors.black,
            indicatorColor: Colors.blue,
            tabs: [
              Tab(text: 'Mes avis'),
              Tab(text: 'Mes stats'),
            ],
          ),
        ),
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
