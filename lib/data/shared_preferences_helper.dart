import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static const String _keyToken = "token";
  static const String _keyUsername = "username";

  // Lưu token vào SharedPreferences
  static Future<void> saveLoginData(String token, String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyToken, token);
    await prefs.setString(_keyUsername, username);
  }

  // Lấy token từ SharedPreferences
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyToken);
  }

  // Lấy tên người dùng từ SharedPreferences
  static Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUsername);
  }

  // Xóa thông tin đăng nhập
  static Future<void> clearLoginData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyToken);
    await prefs.remove(_keyUsername);
  }
}
