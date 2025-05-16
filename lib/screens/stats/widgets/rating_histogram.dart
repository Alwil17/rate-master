import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:rate_master/models/rating.dart';

class RatingHistogram extends StatelessWidget {
  final List<Rating> ratings;

  const RatingHistogram({super.key, required this.ratings});

  @override
  Widget build(BuildContext context) {
    final countPerStar = List.generate(5, (i) => 0); // index 0 = 1 étoile

    for (final r in ratings) {
      final index = r.value.round() - 1;
      if (index >= 0 && index < 5) {
        countPerStar[index]++;
      }
    }

    final maxCount = countPerStar.reduce((a, b) => a > b ? a : b);

    return AspectRatio(
      aspectRatio: 1.6,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: maxCount.toDouble() + 1,
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 28,
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index >= 0 && index < 5) {
                    return Text('${index + 1}★');
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          barGroups: List.generate(5, (i) {
            return BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: countPerStar[i].toDouble(),
                  width: 18,
                  borderRadius: BorderRadius.circular(4),
                  color: Colors.blueAccent,
                ),
              ],
            );
          }),
          gridData: FlGridData(show: false),
          borderData: FlBorderData(show: false),
        ),
      ),
    );
  }
}
