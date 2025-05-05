abstract class ApiRoutes {
  static const String base_url = "http://192.168.50.144:8000";
  static const String base_api = base_url;
  static const String login = "$base_api/login";
  static const String forgetpassword = "$base_api/forgetpassword";
  static const String register = "$base_api/auth/register";
  static const String token = "$base_api/auth/token";
  static const String me = "$base_api/auth/me";
  static const String items = "$base_api/items";
  static const String categories = "$base_api/categories";
  static const String tags = "$base_api/tags";
  static const String ratings = "$base_api/ratings";
}
