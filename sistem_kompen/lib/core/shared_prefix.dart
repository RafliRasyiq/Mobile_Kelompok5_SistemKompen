
import 'package:shared_preferences/shared_preferences.dart';

class Sharedpref {
  static const String USER_TOKEN = "USER_TOKEN";
  static const String USER_ID = '0';

  static Future<void> saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(USER_TOKEN, token);
  }

  static Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(USER_TOKEN) ?? '';
  }

  static Future<void> saveUserId(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(USER_ID, id);
  }

  static Future<String> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(USER_ID) ?? '';
  }
}