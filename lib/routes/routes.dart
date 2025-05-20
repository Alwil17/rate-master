abstract class Routes {
  static const String splash = "/";
  static const String login = "/login";
  static const String register = "/register";
  static const String home = "/home";
  static const String welcome = "/welcome";
  static const String itemDetails = "/:itemId";
  static const String profile = "/profile";
  static const String search = "/search";
  static const String stats = "/stats";
  static const String settings = "/settings";
  static const String notifications = "/notifications";
  static const String about = "/about";
  static const String editProfile = "/editProfile";
}

enum APP_PAGES {
  splash,
  login,
  register,
  home,
  welcome,
  itemDetails,
  profile,
  search,
  stats,
  settings,
  notifications,
  about,
  editProfile,
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
      case APP_PAGES.profile:
        return Routes.profile;
      case APP_PAGES.search:
        return Routes.search;
      case APP_PAGES.stats:
        return Routes.stats;
      case APP_PAGES.settings:
        return Routes.settings;
      case APP_PAGES.notifications:
        return Routes.notifications;
      case APP_PAGES.about:
        return Routes.about;
      case APP_PAGES.editProfile:
        return Routes.editProfile;
    }
  }

  String get toName => name.toUpperCase();
}
