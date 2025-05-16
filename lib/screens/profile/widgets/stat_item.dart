// stats_summary_widget.dart
import 'package:flutter/material.dart';

/// A reusable stat item showing a value and its label.
class StatItem extends StatelessWidget {
  /// The primary text (e.g., "52", "4.8").
  final String value;

  /// The secondary label (e.g., "Avis", "Commentaires").
  final String label;

  const StatItem({
    super.key,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Colors.grey,
              ),
        ),
      ],
    );
  }
}