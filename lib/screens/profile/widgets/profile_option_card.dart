import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:rate_master/shared/theme/theme.dart';

/// A reusable card widget with a title, subtitle, and trailing circular icon button.
class ProfileOptionCard extends StatelessWidget {
  /// Main title text displayed in bold.
  final String title;

  /// Subtitle text displayed in accent color.
  final String subtitle;

  /// IconData for the trailing icon (e.g., Icons.info).
  final PhosphorIconData icon;

  /// Callback when the card is tapped.
  final VoidCallback? onTap;

  const ProfileOptionCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap, // Action au clic
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.accent, width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            // Titre et sous-titre
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 14, color: AppColors.accent),
                ),
              ],
            )),
            // Icône
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                PhosphorIcon(
                  icon,
                  color: AppColors.accent.withOpacity(0.3),
                  size: 30,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
