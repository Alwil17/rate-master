import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:rate_master/providers/auth_provider.dart';
import 'package:rate_master/providers/category_provider.dart';
import 'package:rate_master/providers/item_provider.dart';
import 'package:rate_master/providers/tag_provider.dart';
import 'package:rate_master/shared/widgets/bottom_vector.dart';
import 'package:rate_master/shared/widgets/cicle_vector.dart';
import 'package:rate_master/shared/widgets/top_corner.dart';
import 'package:rate_master/routes/routes.dart';

import '../../generated/assets.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late AuthProvider authProvider;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initApp();
    });
  }

  Future<void> _initApp() async {
    setState(() => _isLoading = true);

    try {
      final itemProvider = Provider.of<ItemProvider>(context, listen: false);
      final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
      final tagProvider = Provider.of<TagProvider>(context, listen: false);

      if (authProvider.isAuthenticated) {
        // Ajoute ici la vérification réelle du token :
        final isTokenValid = await authProvider.verifyToken();

        if (isTokenValid) {
          await Future.wait([
            itemProvider.fetchItems(),
            categoryProvider.fetchCategories(),
            tagProvider.fetchTags(),
          ]);

          if (mounted) {
            setState(() => _isLoading = false);
            context.goNamed(APP_PAGES.home.toName);
          }
        } else {
          // Token invalide -> déconnecte l'utilisateur
          await authProvider.logout();
          if (mounted) {
            setState(() => _isLoading = false);
            context.goNamed(APP_PAGES.welcome.toName);
          }
        }
      } else {
        if (mounted) {
          context.goNamed(APP_PAGES.welcome.toName);
        }
      }
    } catch (e) {
      print("Erreur au lancement de l'app : $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Une erreur est survenue au lancement.'),
        ));
        setState(() => _isLoading = false);
      }
    }
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
                  const SizedBox(height: 15),
                  Visibility(
                      visible: _isLoading, child: CircularProgressIndicator())
                ],
              ),
            ),
          ],
        ));
  }
}
