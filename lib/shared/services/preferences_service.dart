import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  late SharedPreferences _prefs;

  PreferencesService._internal();
  static final PreferencesService instance =
  PreferencesService._internal();
   Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }
   Future<void> setBool(String key, bool value) async =>
      await _prefs.setBool(key, value);

  bool getBool(String key) => _prefs.getBool(key) ?? false;

   Future<void> setString(String key, String value) async =>
      await _prefs.setString(key, value);

  String getString(String key) => _prefs.getString(key) ?? '';
   Future<void> remove(String key) async => await _prefs.remove(key);

   Future<void> clear() async => await _prefs.clear();
}