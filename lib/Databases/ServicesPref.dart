
import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  
/* ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ Keys ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ */
 
  static const kUsername = 'username';
  static const kHomeTable = 'home-table';


/* ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ Fields ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ */

  static late SharedPreferences preferences;


/* ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ Methods ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ */

  static Future<void> init() async =>
    preferences = await SharedPreferences.getInstance();


  static Future<void> setUsername(String name) async =>
    await preferences.setString(kUsername, name);
  static String getUsername() =>
    preferences.getString(kUsername) ?? '';
    
  static Future<void> setHomeTable(int index) async =>
    await preferences.setInt(kHomeTable, index);
  static int getHomeTable() =>
    preferences.getInt(kHomeTable) ?? 0;
}