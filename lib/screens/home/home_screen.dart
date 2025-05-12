import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rate_master/providers/auth_provider.dart';
import 'package:rate_master/providers/item_provider.dart';
import 'package:rate_master/routes/routes.dart';
import 'package:rate_master/screens/home/widgets/recently_rated.dart';
import 'package:rate_master/screens/home/widgets/recommanded_list.dart';
import 'package:rate_master/shared/theme/theme.dart';
import 'package:rate_master/shared/widgets/global_app_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: globalAppBar(context, () {
        // Manual Pull-to-refresh
        itemProvider.fetchItems();
      }),
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
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    TextSpan(
                      text: "${authProvider.user!.name},",
                      style: TextStyle(
                        fontSize: 18,
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
                  color: Colors.white,
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
            _buildSectionTitle(context, locale.recentlyRated),
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
      padding: EdgeInsets.only(left: 5, top: 5, right: 5, bottom: 0),
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
          TextButton(
            onPressed: onViewAllPressed,
            child: Row(children: [PhosphorIcon(PhosphorIconsRegular.caretLeft),PhosphorIcon(PhosphorIconsRegular.caretRight)],),
          ),
        ],
      ),
    );
  }



}
