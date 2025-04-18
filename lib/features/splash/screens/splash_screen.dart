import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:rate_master/core/providers/api_data_provider.dart';
import 'package:rate_master/core/providers/app_state_provider.dart';
import 'package:rate_master/routes/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late AppStateProvider prefs;
  late ApiDataProvider apiData;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    prefs = Provider.of<AppStateProvider>(context, listen: false);
    apiData = Provider.of<ApiDataProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initApp();
    });
  }

  Future<void> _initApp() async {
    setState(() {
      _isLoading = true;
    });

    // Charger les préférences sans perturber la construction initiale
    await prefs.loadPreferences();

    bool isAuthenticated = prefs.loggedIn;

    if (isAuthenticated) {

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        context.goNamed(APP_PAGES.home.toName);
      }
    } else {
      if (mounted) {
        context.goNamed(APP_PAGES.login.toName);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display the logo or splash content here
            ClipRRect(borderRadius: BorderRadius.circular(30),
            child: Image.asset(
              'assets/images/logo.PNG',
              height: 175,
            ),),
            const SizedBox(height: 15),
            Visibility(visible: _isLoading,child: CircularProgressIndicator())
          ],
        ),
      ),
    );
  }
}