import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rate_master/shared/constants/constants.dart';
import 'package:rate_master/routes/routes.dart';
import 'package:rate_master/shared/widgets/bottom_vector.dart';
import 'package:rate_master/shared/widgets/cicle_vector.dart';
import 'package:rate_master/shared/widgets/top_corner.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../shared/theme/theme.dart';
import '../../generated/assets.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            top: 0,
            right: 0,
            child: CustomPaint(
              painter: TopVector(),
              child: SizedBox(width: 176, height: 190),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: CustomPaint(
              painter: BottomVector(),
              child: SizedBox(width: 176, height: 190),
            ),
          ),
          Positioned(
            right: 30,
            bottom: 110,
            child: CustomPaint(
              painter: CircleVector(),
              child: SizedBox(width: 110, height: 110),
            ),
          ),
          Positioned(
            left: 50,
            top: 100,
            child: CustomPaint(
              painter: CircleVector(),
              child: SizedBox(width: 65, height: 65),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Display the logo or splash content here
                ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.asset(
                    Assets.imagesShootingStar,
                    height: 175,
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  AppLocalizations.of(context)!.welcomeTo(Constants.appName),
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 15),
                Text(
                  AppLocalizations.of(context)!.appSlogan,
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: _buildActionButton(),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => context.pushNamed(APP_PAGES.login.toName),
        style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 15),
            shape: StadiumBorder(),
            backgroundColor: AppColors.accent),
        child: Text(
          AppLocalizations.of(context)!.getStarted,
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }
}
