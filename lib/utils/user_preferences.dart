import 'package:shared_preferences/shared_preferences.dart';

class UserSimplePreferences {
  static late SharedPreferences _preferences;
  static const _keyfirstrun = 'firstrun';
  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setFirstRun(bool firstrun) async =>
      await _preferences.setBool(_keyfirstrun, firstrun);

  static bool? getFirstRun() => _preferences.getBool(_keyfirstrun);
}
