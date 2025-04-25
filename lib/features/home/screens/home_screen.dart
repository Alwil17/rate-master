import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rate_master/core/providers/auth_provider.dart';
import 'package:rate_master/core/theme/theme.dart';
import 'package:rate_master/shared/widgets/global_app_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  late AuthProvider authProvider;

  @override
  void initState() {
    super.initState();

    authProvider = Provider.of<AuthProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: globalAppBar(context, null),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and Greeting
            RichText(
              text: TextSpan(
                  style: TextStyle(
                    fontFamily: 'OpenSans',
                    color: AppColors.secondaryBackground,
                  ),
                  children: [
                    TextSpan(
                      text: "${AppLocalizations.of(context)!.welcome} ",
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
            SizedBox(height: 5),

            // Search Bar
            TextField(
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.makeASearch,
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),

            _buildSectionTitle(context, AppLocalizations.of(context)!.recommandedForYou),
            
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
