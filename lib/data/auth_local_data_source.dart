import 'package:nttcs/core/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthLocalDataSource {
  AuthLocalDataSource(this.sf);

  final SharedPreferences sf;

  Future<void> saveString(String key, String value) async {
    await sf.setString(key, value);
  }

  Future<void> saveInt(String key, int value) async {
    await sf.setInt(key, value);
  }

  Future<String?> getToken() async {
    return sf.getString(AuthDataConstants.token);
  }
//
// Future<void> deleteToken() async {
//   await sf.remove(AuthDataConstants.tokenKey);
// }
}
