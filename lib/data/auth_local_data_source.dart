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

  dynamic getValue(List<String> keys) {
    List<dynamic> values = [];

    for (String key in keys) {
      dynamic value = sf.get(key);
      values.add(value);
    }

    return values;
  }

}
