import 'dart:convert';

import 'package:go_router/go_router.dart';
import 'package:rate_master/features/splash/screens/splash_screen.dart';
import 'package:rate_master/routes/routes.dart';
import 'package:rate_master/screens/error_screen.dart';

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
      /*GoRoute(
          path: APP_PAGES.home.toPath,
          name: APP_PAGES.home.toName,
          builder: (context, state) => HomeScreen(),),
      GoRoute(
        path: APP_PAGES.splash.toPath,
        name: APP_PAGES.splash.toName,
        builder: (context, state) => SplashScreen(),
      ),
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
      ),
      GoRoute(
        path: APP_PAGES.register.toPath,
        name: APP_PAGES.register.toName,
        builder: (context, state) => RegisterScreen(),
      ),*/
    ],
    debugLogDiagnostics: true,
    errorBuilder: (context, state) => ErrorScreen(error: state.error),
    redirect: (context, state) {
      final splashLocation = state.namedLocation(APP_PAGES.splash.toName);
      //print(isLogedIn);
      // Else Don't do anything
      return null;
    },
  );
}
