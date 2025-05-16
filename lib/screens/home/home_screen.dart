import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rate_master/providers/auth_provider.dart';
import 'package:rate_master/providers/item_provider.dart';
import 'package:rate_master/routes/routes.dart';
import 'package:rate_master/screens/home/widgets/recently_rated.dart';
import 'package:rate_master/screens/home/widgets/recommanded_list.dart';
import 'package:rate_master/shared/constants/constants.dart';
import 'package:rate_master/shared/theme/theme.dart';
import 'package:rate_master/shared/widgets/expanding_bottom_nav.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'widgets/home_app_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  late final AuthProvider authProvider;
  late final ItemProvider itemProvider;

  @override
  void initState() {
    super.initState();

    // Get providers withouth listening for changes
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    itemProvider = Provider.of<ItemProvider>(context, listen: false);
  }

  Future<void> _handlePopInvokedWithResult(BuildContext context) async {
    final locale = AppLocalizations.of(context)!;
    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(locale.exitApp),
        content: Text(locale.exitConfirmation),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: Text(locale.cancel)),
          TextButton(onPressed: () => Navigator.of(ctx).pop(true), child: Text(locale.exit)),
        ],
      ),
    ) ?? false;

    if (shouldExit) {
      SystemNavigator.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the locale for localization
    return PopScope<bool>(
      // Allow pop events to be intercepted
      canPop: false,
        onPopInvokedWithResult: (ctxt, result) async {
          await _handlePopInvokedWithResult(context);
        },
      child: _buildHomeBody(context),
    );
  }

  Widget _buildHomeBody(BuildContext context){
    final locale = AppLocalizations.of(context)!;
    return Scaffold(
      key: _scaffoldKey,
      appBar: homeAppBar(context, null),
      bottomNavigationBar: ExpandingBottomNav(items: Constants.navItems),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting
            RichText(
              text: TextSpan(
                  style: TextStyle(
                    fontFamily: 'OpenSans',
                    color: AppColors.secondaryBackground,
                  ),
                  children: [
                    TextSpan(
                      text: "${locale.welcome} ",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    TextSpan(
                      text: "${authProvider.user!.name},",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ]),
            ),
            const SizedBox(height: 12),

            // Search Bar (clickable)
            InkWell(
              onTap: () => context.pushNamed(APP_PAGES.search.toName),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: AppColors.accent),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, color: Colors.grey),
                    SizedBox(width: 10),
                    Text(
                      locale.makeASearch,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            /// Recommanded section
            // Title
            _buildSectionTitle(context, locale.recommandedForYou),
            // Content
            SizedBox(height: 200, child: buildRecommandedList(context)),
            const SizedBox(height: 16),

            /// To rate section
            // Title
            _buildSectionTitle(context, locale.recentlyRated,
                onViewAllPressed: () =>
                    context.pushNamed(APP_PAGES.stats.toName)),
            // Content
            // Par exemple :
            SizedBox(
              height: 220, // fixe ou calculé via MediaQuery
              child: buildRecentlyRated(context),
            ),
          ],
        ),
      ),
    );
  }

  // Helper to build section titles with "Tout voir" button
  Widget _buildSectionTitle(BuildContext context, String title,
      {VoidCallback? onViewAllPressed}) {
    return Padding(
      padding: EdgeInsets.only(left: 5, top: 5, right: 5, bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
          onViewAllPressed != null
              ? TextButton(
                  onPressed: onViewAllPressed,
                  child: Row(
                    children: [
                      Text(
                        AppLocalizations.of(context)!.viewAll,
                        style: TextStyle(color: Colors.blue),
                      ),
                      PhosphorIcon(
                        PhosphorIconsRegular.arrowRight,
                        size: 12,
                        color: Colors.blue,
                      )
                    ],
                  ),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
