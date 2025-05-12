import 'dart:convert';

import 'package:go_router/go_router.dart';
import 'package:rate_master/screens/auth/login_screen.dart';
import 'package:rate_master/screens/auth/register_screen.dart';
import 'package:rate_master/screens/home/home_screen.dart';
import 'package:rate_master/screens/init/splash_screen.dart';
import 'package:rate_master/screens/init/welcome_screen.dart';
import 'package:rate_master/routes/routes.dart';
import 'package:rate_master/screens/items/item_detail_screen.dart';
import 'package:rate_master/screens/profile/profile_screen.dart';
import 'package:rate_master/screens/search/search_screen.dart';
import 'package:rate_master/shared/error_screen.dart';

class AppRouter {
  //late final PreferencesService appService;
  GoRouter get router => _goRouter;

  AppRouter();

  late final GoRouter _goRouter = GoRouter(
    initialLocation: APP_PAGES.splash.toPath,
    routes: <GoRoute>[
      GoRoute(
        path: APP_PAGES.splash.toPath,
        name: APP_PAGES.splash.toName,
        builder: (context, state) => SplashScreen(),
      ),
      GoRoute(
        path: APP_PAGES.welcome.toPath,
        name: APP_PAGES.welcome.toName,
        builder: (context, state) => WelcomeScreen(),
      ),
      GoRoute(
        path: APP_PAGES.login.toPath,
        name: APP_PAGES.login.toName,
        builder: (context, state) => LoginScreen(),
      ),
      GoRoute(
        path: APP_PAGES.register.toPath,
        name: APP_PAGES.register.toName,
        builder: (context, state) => RegisterScreen(),
      ),
      GoRoute(
        path: APP_PAGES.home.toPath,
        name: APP_PAGES.home.toName,
        builder: (context, state) => HomeScreen(),
        routes: [
          GoRoute(
            path: APP_PAGES.itemDetails.toPath,
            name: APP_PAGES.itemDetails.toName,
            builder: (context, state) => ItemDetailScreen(
                itemId:
                int.parse(state.pathParameters['itemId'].toString())),
          ),
        ]
      ),
      GoRoute(
        path: APP_PAGES.profile.toPath,
        name: APP_PAGES.profile.toName,
        builder: (context, state) => ProfileScreen(),
      ),
      GoRoute(
        path: APP_PAGES.search.toPath,
        name: APP_PAGES.search.toName,
        builder: (context, state) => SearchScreen(),
      ),
      /*
      GoRoute(
        path: APP_PAGES.login.toPath,
        name: APP_PAGES.login.toName,
        builder: (context, state) => LoginScreen(),
        routes: [
          GoRoute(
            path: APP_PAGES.forgetPassword.toPath,
            name: APP_PAGES.forgetPassword.toName,
            builder: (context, state) => ForgetPasswordScreen(),
          ),
        ]
      ),*/
    ],
    debugLogDiagnostics: true,
    errorBuilder: (context, state) => ErrorScreen(error: state.error),
    redirect: (context, state) {
      /*final auth = context.read<AuthProvider>();
      final isLoggedIn = auth.isAuthenticated;
      final loggingIn = state.matchedLocation == Routes.login;

      if (!isLoggedIn && !loggingIn) return Routes.login;
      if (isLoggedIn && state.matchedLocation == Routes.login) return APP_PAGES.welcome.toName;*/

      return null;
    },
  );
}
