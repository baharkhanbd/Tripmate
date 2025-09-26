import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefHelper {
  static SharedPreferences? _prefs;

  // Initialize একবার অ্যাপ চালুর সময়
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // টোকেন ফেচ করা (API কল করার আগে ব্যবহার করা হবে)
  static String? getToken() {
    return _prefs?.getString("token");
  }

  // টোকেন সেট করা (লগইনের সময়)
  static Future<void> setToken(String token) async {
    await _prefs?.setString("token", token);
  }

  // লগআউট করলে টোকেন রিমুভ করা
  static Future<void> clearToken() async {
    await _prefs?.remove("token");
  }
}