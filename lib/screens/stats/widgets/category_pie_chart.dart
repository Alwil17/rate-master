import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:rate_master/models/item.dart';
import 'package:rate_master/models/rating.dart';

class CategoryPieChart extends StatelessWidget {
  final List<Rating> reviews;
  final List<Item> items;

  const CategoryPieChart({
    super.key,
    required this.reviews,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {

    final Map<String, int> categoryCounts = {};
    for (final r in reviews) {
      final item = items.firstWhere(
            (i) => i.id == r.itemId,
        orElse: () => Item(id: 0, name: 'Unknown', categories: []),
      );
      for (final cat in item.categories) {
        categoryCounts[cat.name] = (categoryCounts[cat.name] ?? 0) + 1;
      }
    }
    if (categoryCounts.isEmpty) {
      return const Center(child: Text('No category data'));
    }

    final total = categoryCounts.values.fold<int>(0, (a, b) => a + b);
    final colors = _generateColors(categoryCounts.length);

    final sections = <PieChartSectionData>[];
    int idx = 0;
    categoryCounts.forEach((name, count) {
      sections.add(PieChartSectionData(
        value: count.toDouble(),
        title: '${(count / total * 100).toStringAsFixed(1)}%',
        color: colors[idx],
        radius: 50,
        titleStyle: const TextStyle(
            fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
      ));
      idx++;
    });

    // Pie + legend
    return AspectRatio(
      aspectRatio: 1.4,
      child: Row(
        children: [
          // PieChart
          Expanded(
            flex: 2,
            child: PieChart(
              PieChartData(
                sections: sections,
                sectionsSpace: 2,
                centerSpaceRadius: 24,
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Legend
          Expanded(
            flex: 1,
            child: ListView(
              children: [
                for (int i = 0; i < categoryCounts.length; i++) ...[
                  _LegendTile(
                    color: colors[i],
                    label: categoryCounts.keys.elementAt(i),
                    count: categoryCounts.values.elementAt(i),
                    total: total,
                  ),
                  const SizedBox(height: 6),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

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

/// A widget that displays a legend tile for the pie chart.
class _LegendTile extends StatelessWidget {
  final Color color;
  final String label;
  final int count;
  final int total;

  const _LegendTile({
    required this.color,
    required this.label,
    required this.count,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final percent = (count / total * 100).toStringAsFixed(1);
    return Row(
      children: [
        Container(width: 12, height: 12, color: color),
        const SizedBox(width: 6),
        Expanded(child: Text(label, overflow: TextOverflow.ellipsis)),
        const SizedBox(width: 6),
        Text('$percent%'),
      ],
    );
  }
}
