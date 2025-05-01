import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  final String authLogin = "AUTH_LOGIN";
  final String tokenLogin = "TOKEN";

  Future<bool> setLogin() async {
    final pref = await SharedPreferences.getInstance();
    return pref.setBool(authLogin, true);
  }

  Future<bool> getLogin() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getBool(authLogin) ?? false;
  }

  Future<bool> logout() async {
    final pref = await SharedPreferences.getInstance();
    return pref.setBool(authLogin, false);
  }

  Future<bool> setToken(String token) async {
    final pref = await SharedPreferences.getInstance();
    return pref.setString(tokenLogin, token);
  }

  Future<String> getToken() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString(tokenLogin) ?? "";
  }

  Future<bool> deleteToken() async {
    final pref = await SharedPreferences.getInstance();
    return pref.setString(tokenLogin, "");
  }
}
