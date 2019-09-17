import 'package:messio/config/Constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedObjects {
  static CachedSharedPreferences prefs;
}

class CachedSharedPreferences {
  static SharedPreferences sharedPreferences;
  static CachedSharedPreferences instance;
  static final cachedKeyList = {
    Constants.sessionUid,
    Constants.sessionUsername,
    Constants.sessionName
  };
  static Map<String, dynamic> map = Map();

  static Future<CachedSharedPreferences> getInstance() async {
    sharedPreferences = await SharedPreferences.getInstance();
    for(String key in cachedKeyList) {
      map[key] = sharedPreferences.getString(key);
    }
    if (instance == null) instance = CachedSharedPreferences();
    return instance;
  }

  String getString(String key) {
    if (cachedKeyList.contains(key)) {
      return map[key];
    }
    return sharedPreferences.getString(key);
  }

  Future<bool> setString(String key, String value) async {
    bool result = await sharedPreferences.setString(key, value);
    if (result)
      map[key] = value;
    return result;
  }
}
