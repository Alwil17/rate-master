abstract class Routes {
  static const String splash = "/";
  static const String login = "/login";
  static const String register = "/register";
  static const String home = "/home";
}

enum APP_PAGES {
  splash,
  login,
  register,
  home,
}

extension AppPageExtension on APP_PAGES {
  String get toPath {
    switch (this) {
      case APP_PAGES.splash:
        return "/";
      case APP_PAGES.login:
        return "/login";
      case APP_PAGES.register:
        return "/register";
      case APP_PAGES.home:
        return "/home";
      default:
        return "/";
    }
  }

  String get toName {
    switch (this) {
      case APP_PAGES.home:
        return "HOME";
      case APP_PAGES.login:
        return "LOGIN";
      case APP_PAGES.register:
        return "REGISTER";
      case APP_PAGES.splash:
        return "SPLASH";
      default:
        return "SPLASH";
    }
  }
}
