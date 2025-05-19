import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:rate_master/models/nav_item.dart';
import 'package:rate_master/routes/routes.dart';

class Constants {
  Constants._();

  static const String appName = "Rate Master";

  static List<NavItem> navItems = [
    NavItem(name: APP_PAGES.home.toName, icon: PhosphorIconsDuotone.house, label: 'Home'),
    NavItem(name: APP_PAGES.search.toName, icon: PhosphorIconsDuotone.listStar, label: 'Search'),
    NavItem(name: APP_PAGES.stats.toName, icon: PhosphorIconsDuotone.chartBar, label: 'Stats'),
    NavItem(name: APP_PAGES.settings.toName, icon: PhosphorIconsDuotone.gear, label: 'Settings'),
  ];
}