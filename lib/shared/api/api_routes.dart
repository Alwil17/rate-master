abstract class ApiRoutes {
  static const String baseUrl = "https://rating-api-fvz9.onrender.com";
  static const String baseApi = baseUrl;
  static const String forgetPassword = "$baseApi/forgetpassword";
  static const String register = "$baseApi/auth/register";
  static const String token = "$baseApi/auth/token";
  static const String me = "$baseApi/auth/me";
  static const String items = "$baseApi/items";
  static const String categories = "$baseApi/categories";
  static const String tags = "$baseApi/tags";
  static const String ratings = "$baseApi/ratings";
  static const String users = "$baseApi/users";
  static const String deleteAccount = "$baseApi/auth/remove";
  static const String updateUser = "$baseApi/auth/edit";
  static const String refreshToken = "$baseApi/auth/refresh";
}
