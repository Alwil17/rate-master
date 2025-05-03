abstract class Routes {
  static const String splash = "/";
  static const String login = "/login";
  static const String register = "/register";
  static const String home = "/home";
  static const String welcome = "/welcome";
  static const String itemDetails = "/:itemId";
}

enum APP_PAGES {
  splash,
  login,
  register,
  home,
  welcome,
  itemDetails,
}

extension AppPageExtension on APP_PAGES {
  String get toPath {
    switch (this) {
      case APP_PAGES.splash:
        return Routes.splash;
      case APP_PAGES.login:
        return Routes.login;
      case APP_PAGES.register:
        return Routes.register;
      case APP_PAGES.home:
        return Routes.home;
      case APP_PAGES.welcome:
        return Routes.welcome;
      case APP_PAGES.itemDetails:
        return Routes.itemDetails;
    }
  }

  String get toName => name.toUpperCase();
}
