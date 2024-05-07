import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static final String _keyUserID = "userID";
  static final String _keyPassword = "password";
  static final String _keyEmail = "email";
  static final String _keyLoginState = "loginState";

  Future<void> init() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
  }

  Future<void> saveLoginState(bool? login) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (login != null){
      await prefs.setBool(_keyLoginState, login);
    }
    else{
      print("loginState is null");
    }
  }

  Future<bool?> getLoginState() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyLoginState);
  }

  Future<void> saveUserID(String? userID) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (userID != null){
      await prefs.setString(_keyUserID, userID);
    }
    else{
      print("userID is null");
    }
  }

  Future<String?> getUserID() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserID);
  }

  Future<void> savePassword(String password) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyPassword, password);
  }

  Future<String?> getPassword() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyPassword);
  }
  Future<void> saveEmail(String? email) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (email != null){
      await prefs.setString(_keyEmail, email);
    }
    else{
      print("email is null");
    }
  }

  Future<String?> getEmail() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyEmail);
  }
}
