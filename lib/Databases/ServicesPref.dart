
import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  
/* ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ Keys ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ */
 
  static const kUsername = 'username';
  static const kHomeTable = 'home-table';
  static const kDarkMode = 'dark-mode';
  static const kDateCreated = 'date-created';


/* ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ Fields ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ */

  static late SharedPreferences preferences;


/* ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ Methods ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ */

  static Future<void> init() async =>
    preferences = await SharedPreferences.getInstance();


  static String get username =>
    preferences.getString(kUsername) ?? '';
  static Future<void> setUsername(String name) async =>
    await preferences.setString(kUsername, name);
    
  static int get homeTable =>
    preferences.getInt(kHomeTable) ?? 0;
  static Future<void> setHomeTable(int index) async =>
    await preferences.setInt(kHomeTable, index);
    
  static bool get isDarkMode =>
    preferences.getBool(kDarkMode) ?? false;
  static Future<void> setDarkMode(bool val) async =>
    await preferences.setBool(kDarkMode, val);
    
  static DateTime get dateCreated {
    String? dt = preferences.getString(kDateCreated);
    return dt == null
    ? DateTime.now()
    : DateTime.parse(dt);
  }
  static Future<void> setDateCreated(DateTime dt) async =>
    await preferences.setString(kDateCreated, dt.toIso8601String());
}