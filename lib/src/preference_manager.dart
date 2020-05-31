part of fat_framework;

/// 偏好设置管理
class FatPreferenceManager extends FatService {
  SharedPreferences _prefs;

  @override
  initialize() async {
    super.initialize();

    _prefs = await SharedPreferences.getInstance();
  }

  Future<bool> setBool(String key, bool value) async {
    return await _prefs.setBool(key, value);
  }

  bool getBool(String key) {
    return _prefs.getBool(key);
  }

  Future<bool> setInt(String key, int value) async {
    return await _prefs.setInt(key, value);
  }

  int getInt(String key) {
    return _prefs.getInt(key);
  }

  Future<bool> setString(String key, String value) async {
    return await _prefs.setString(key, value);
  }

  String getString(String key) {
    return _prefs.getString(key);
  }

  Future<bool> remove(String key) {
    return _prefs.remove(key);
  }
}
