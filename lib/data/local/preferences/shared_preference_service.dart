import 'package:shared_preferences/shared_preferences.dart';
import 'package:story_app/data/model/login_model.dart';

class SharedPreferenceService {
  final SharedPreferences _sharedPreferences;

  SharedPreferenceService(this._sharedPreferences);

  static const String _keyToken = "TOKEN";
  static const String _isLogin = "IS_LOGIN";

  Future<void> setLogin(Login login) async {
    try {
      await _sharedPreferences.setString(_keyToken, login.token);
      await _sharedPreferences.setBool(_isLogin, true);
    } catch (e) {
      throw Exception("Failed to set login data");
    }
  }

  Future<Login> getLogin() async {
    return Login(
      token: _sharedPreferences.getString(_keyToken) ?? "",
      isLogin: _sharedPreferences.getBool(_isLogin) ?? false,
    );
  }

  Future<void> logout() async {
    try {
      await _sharedPreferences.remove(_keyToken);
      await _sharedPreferences.setBool(_isLogin, false);
    } catch (e) {
      throw Exception("Failed to logout login data");
    }
  }
}
