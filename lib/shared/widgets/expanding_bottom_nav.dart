import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:rate_master/models/nav_item.dart';
import 'package:rate_master/shared/theme/theme.dart';

/// Reusable expanding bottom nav
class ExpandingBottomNav extends StatelessWidget {
  final List<NavItem> items;

  /// Pass the list of nav items in order (left→right)
  const ExpandingBottomNav({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final router = GoRouter.of(context);
    final location = ModalRoute.of(context)?.settings.name;
    // Find which index matches current route
    final currentIndex = items.indexWhere((item) => location == item.name);
    // if no match, default to 0
    final selectedIndex = currentIndex < 0 ? 0 : currentIndex;

    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (i) {
          final nav = items[i];
          final isSelected = i == selectedIndex;

          return InkWell(
            onTap: () {
              if (!isSelected) router.pushNamed(nav.name);
            },
            splashColor: Colors.transparent,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              width: isSelected ? 100 : 40,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.accent : Colors.transparent,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PhosphorIcon(nav.icon, color: isSelected ? Colors.white : Theme.of(context).iconTheme.color),
                  if (isSelected) ...[
                    const SizedBox(width: 6),
                    Text(
                      nav.label,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}