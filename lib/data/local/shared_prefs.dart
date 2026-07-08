import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static const String _accessTokenKey = 'access_token';
  static const String _userID = 'user_id';
  static const String _ID = 'id';
  static const String _referalPoints = 'referal_points';
  static const String _referalCode = 'referal_code';

  static SharedPreferences? prefs;


  static Future<void> saveAccessToken(String accessToken) async {
    prefs?.setString(_accessTokenKey, accessToken);
  }

  static Future<void> saveUserID(String accessToken) async {
    prefs?.setString(_userID, accessToken);
  }

  static Future<String?> getUserID() async {
    prefs = await SharedPreferences.getInstance();
    return prefs?.getString(_userID);
  }

  static Future<void> saveID(String accessToken) async {
    prefs?.setString(_ID, accessToken);
  }

  static Future<String?> getID() async {
    prefs = await SharedPreferences.getInstance();
    return prefs?.getString(_ID);
  }

  static Future<void> saveReferalPoints(String accessToken) async {
    prefs?.setString(_referalPoints, accessToken);
  }

  static Future<String?> getReferalPoints() async {
    prefs = await SharedPreferences.getInstance();
    return prefs?.getString(_referalPoints);
  }

  static Future<void> saveReferalCode(String accessToken) async {
    prefs?.setString(_referalCode, accessToken);
  }

  static Future<String?> getReferalCode() async {
    prefs = await SharedPreferences.getInstance();
    return prefs?.getString(_referalCode);
  }

  static Future<String?> getAccessToken() async {
    prefs = await SharedPreferences.getInstance();
    return prefs?.getString(_accessTokenKey);
  }
  static Future<void> clearPref() async {
    prefs = await SharedPreferences.getInstance();
    await prefs?.clear();
  }
}
