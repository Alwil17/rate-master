import 'dart:convert';

import 'package:go_router/go_router.dart';
import 'package:rate_master/screens/auth/login_screen.dart';
import 'package:rate_master/screens/auth/register_screen.dart';
import 'package:rate_master/screens/home/home_screen.dart';
import 'package:rate_master/screens/init/splash_screen.dart';
import 'package:rate_master/screens/init/welcome_screen.dart';
import 'package:rate_master/routes/routes.dart';
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
      )
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
