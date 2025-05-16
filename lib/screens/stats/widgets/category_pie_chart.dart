import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:rate_master/models/item.dart';
import 'package:rate_master/models/rating.dart';

class CategoryPieChart extends StatelessWidget {
  /// All ratings by the user
  final List<Rating> reviews;

  /// Master list of items (so we can look up categories)
  final List<Item> items;

  const CategoryPieChart({
    super.key,
    required this.reviews,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    // 1) Count reviews per category
    final Map<String, int> categoryCounts = {};

    for (final r in reviews) {
      // find the item this rating refers to
      final item = items.firstWhere(
            (i) => i.id == r.itemId,
        orElse: () => Item(id: 0, name: 'Unknown', categories: []),
      );

      // if item has multiple categories, you may want to count each;
      // here we count each category separately
      for (final cat in item.categories) {
        categoryCounts[cat.name] = (categoryCounts[cat.name] ?? 0) + 1;
      }
      // if you only want the first category:
      // if (item.categories.isNotEmpty) {
      //   final name = item.categories.first.name;
      //   categoryCounts[name] = (categoryCounts[name] ?? 0) + 1;
      // }
    }

    // if no data, show a placeholder
    if (categoryCounts.isEmpty) {
      return Center(child: Text('No category data'));
    }

    // 2) Prepare chart sections
    final total = categoryCounts.values.fold<int>(0, (a, b) => a + b);
    final colors = _generateColors(categoryCounts.length);

    final sections = <PieChartSectionData>[];
    int idx = 0;
    categoryCounts.forEach((name, count) {
      final percent = (count / total * 100).toStringAsFixed(1);
      sections.add(PieChartSectionData(
        value: count.toDouble(),
        title: '$percent%',
        color: colors[idx],
        radius: 60,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ));
      idx++;
    });

    // 3) Build the chart
    return AspectRatio(
      aspectRatio: 1.3,
      child: PieChart(
        PieChartData(
          sections: sections,
          sectionsSpace: 2,
          centerSpaceRadius: 32,
        ),
      ),
    );
  }

  /// A simple palette—will cycle if you have more categories than colors.
  List<Color> _generateColors(int count) {
    const baseColors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.cyan,
      Colors.amber,
      Colors.indigo,
      Colors.brown,
    ];
    return List.generate(count, (i) => baseColors[i % baseColors.length]);
  }
}
