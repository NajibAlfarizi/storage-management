import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUtil {
  static const String _tokenKey = 'token';
  static const String _tokenExpiryKey = 'tokenExpiry';
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  static Future<void> saveToken(String token, DateTime tokenExpiry) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_tokenExpiryKey, tokenExpiry.toIso8601String());
  }

  static Future<DateTime?> getTokenExpiry() async {
    final prefs = await SharedPreferences.getInstance();
    final expiryString = prefs.getString(_tokenExpiryKey);
    return expiryString != null ? DateTime.parse(expiryString) : null;
  }

  static Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_tokenExpiryKey);
  }
}
