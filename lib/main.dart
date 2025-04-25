import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_file.dart';
import 'package:provider/provider.dart';
import 'package:rate_master/providers/auth_provider.dart';
import 'package:rate_master/providers/item_provider.dart';
import 'package:rate_master/services/api_service.dart';
import 'package:rate_master/services/item_service.dart';
import 'package:rate_master/shared/theme/theme.dart';
import 'package:rate_master/routes/app_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'providers/app_state_provider.dart';

final AppRouter appRouter = AppRouter();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
        create: (_) => AppStateProvider(prefs)..loadPreferences()),
    ChangeNotifierProvider(create: (_) => AuthProvider(prefs)),
    Provider<ApiService>(create: (_) => ApiService(prefs)),
    ProxyProvider<ApiService, ItemService>(
      update: (_, api, __) => ItemService(api),
    ),
    ChangeNotifierProxyProvider<ItemService, ItemProvider>(
      create: (_) => ItemProvider(ItemService(ApiService(prefs))),
      update: (_, itemService, previous) => previous!..itemService,
    )
  ], child: MyApp()));

  configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false
    ..customAnimation = CustomAnimation();
}

class CustomAnimation extends EasyLoadingAnimation {
  CustomAnimation();

  @override
  Widget buildWidget(
      Widget child,
      AnimationController controller,
      AlignmentGeometry alignment,
      ) {
    return Opacity(
      opacity: controller.value,
      child: RotationTransition(
        turns: controller,
        child: child,
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final GoRouter goRouter = appRouter.router;

    return Consumer<AppStateProvider>(
        builder: (context, appStateProvider, child) {
          return MaterialApp.router(
            title: 'RateMaster',
            theme: appTheme,
            localizationsDelegates: [
              AppLocalizations.delegate, // Add this line
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [
              Locale('fr'), // french
              Locale('en'), // English
            ],
            locale: Locale(appStateProvider.locale),
            routeInformationProvider: goRouter.routeInformationProvider,
            routeInformationParser: goRouter.routeInformationParser,
            routerDelegate: goRouter.routerDelegate,
            builder: EasyLoading.init(),
          );
        });
  }
}