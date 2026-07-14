import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static const String _accessTokenKey = 'access_token';
  static const String _userID = 'user_id';
  static const String _ID = 'id';
  static const String _referalPoints = 'referal_points';
  static const String _referalCode = 'referal_code';
  static const String _isNewUser = 'is_new_user';
  static const String _nationality = 'nationality';
  static const String _onboardingDone = 'onboarding_done';

  static SharedPreferences? prefs;

  /// True once the user has finished the new-user + region onboarding. When set,
  /// "Get Started" skips the onboarding screens and goes straight to login.
  static Future<void> saveOnboardingDone(bool done) async {
    prefs = await SharedPreferences.getInstance();
    await prefs?.setBool(_onboardingDone, done);
  }

  static Future<bool> getOnboardingDone() async {
    prefs = await SharedPreferences.getInstance();
    if (prefs?.getBool(_onboardingDone) ?? false) return true;
    // Backward-compat: users who already picked a region (saved before this
    // flag existed) are also considered onboarded.
    final nation = prefs?.getString(_nationality);
    return nation != null && nation.isNotEmpty;
  }

  // ---- Onboarding selections (used later on the signup screen) ----

  /// Whether the user answered "Yes" to "Are you new here?".
  static Future<void> saveIsNewUser(bool isNewUser) async {
    prefs = await SharedPreferences.getInstance();
    await prefs?.setBool(_isNewUser, isNewUser);
  }

  static Future<bool> getIsNewUser() async {
    prefs = await SharedPreferences.getInstance();
    return prefs?.getBool(_isNewUser) ?? false;
  }

  /// Nationality/region selection: "singapore" (Local) or
  /// "outside_singapore" (Tourist/foreigner).
  static Future<void> saveNationality(String nationality) async {
    prefs = await SharedPreferences.getInstance();
    await prefs?.setString(_nationality, nationality);
  }

  static Future<String?> getNationality() async {
    prefs = await SharedPreferences.getInstance();
    return prefs?.getString(_nationality);
  }


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
