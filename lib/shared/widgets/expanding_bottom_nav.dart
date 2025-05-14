import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rate_master/models/nav_item.dart';

/// Reusable expanding bottom nav
class ExpandingBottomNav extends StatelessWidget {
  final List<NavItem> items;

  /// Pass the list of nav items in order (left→right)
  const ExpandingBottomNav({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final router = GoRouter.of(context);
    final location = router.routerDelegate.currentConfiguration.uri.toString();
    // Find which index matches current route
    final currentIndex = items.indexWhere((item) => location.startsWith(item.name));
    // if no match, default to 0
    final selectedIndex = currentIndex < 0 ? 0 : currentIndex;

    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      elevation: 8,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(items.length, (i) {
            final nav = items[i];
            final isSelected = i == selectedIndex;

            return InkWell(
              onTap: () {
                if (!isSelected) router.go(nav.name);
              },
              splashColor: Colors.transparent,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                width: isSelected ? 100 : 40,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFFD0E9FF) : Colors.transparent,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(nav.icon, color: isSelected ? Colors.blue : Colors.grey),
                    if (isSelected) ...[
                      const SizedBox(width: 6),
                      Text(
                        nav.label,
                        style: TextStyle(
                          color: Colors.blue,
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
      ),
    );
  }
}