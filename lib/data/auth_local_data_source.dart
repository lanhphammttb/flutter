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

  String? getToken()  {
    return sf.getString(Constants.token);
  }

  String? getName() {
    return sf.getString(Constants.name);
  }

  Future<int?> getSiteId() async{
    return sf.getInt(Constants.id);
  }

  String? getSelectCode()  {
    return sf.getString(Constants.selectCode);
  }

  String? getCode()  {
    return sf.getString(Constants.code);
  }
//
// Future<void> deleteToken() async {
//   await sf.remove(Constants.tokenKey);
// }
}
