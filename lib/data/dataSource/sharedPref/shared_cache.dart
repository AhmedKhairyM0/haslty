import 'package:shared_preferences/shared_preferences.dart';

class SharedCache {
  // singleton pattern

  SharedCache._internal();

  static final SharedCache _instance = SharedCache._internal();

  factory SharedCache() {
    return _instance;
  }

  static late SharedPreferences _sharedPreferences;

  static Future init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  final balanceKey = 'balance';
  final localeKey = 'locale';
  final themeKey = 'theme';
  final firstOpenKey = 'firstOpen';

  Future<bool> setBalance(String key, double balance) async =>
      await _sharedPreferences.setDouble(key, balance);

  double getBalance(String key) => _sharedPreferences.getDouble(key) ?? 0.0;

  Future<bool> setLocale(String key, String locale) async =>
      await _sharedPreferences.setString(key, locale);

  String getLocale(String key) => _sharedPreferences.getString(key) ?? 'en';

  Future<bool> setTheme(String key, int balance) async =>
      await _sharedPreferences.setInt(key, balance);

  int getTheme(String key) => _sharedPreferences.getInt(key) ?? 0;

  Future<bool> setFirstTime(String key, bool value) async =>
      await _sharedPreferences.setBool(key, value);

  bool getFirstTime(String key) => _sharedPreferences.getBool(key) ?? false;
}
