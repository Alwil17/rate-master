import 'package:phosphor_flutter/phosphor_flutter.dart';

/// A single nav item
class NavItem {
  final String name;       // route name
  final PhosphorIconData icon;
  final String label;
  NavItem({required this.name, required this.icon, required this.label});
}