abstract class ApiRoutes {
  static const String base_url = "http://192.168.17.144:8000";
  static const String base_api = base_url;
  static const String login = "$base_api/login";
  static const String forgetpassword = "$base_api/forgetpassword";
  static const String register = "$base_api/auth/register";
  static const String token = "$base_api/auth/token";
  static const String me = "$base_api/auth/me";
}
