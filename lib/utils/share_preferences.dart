import 'package:shared_preferences/shared_preferences.dart';

class SharePreferencesUtils {
  static late SharedPreferences _sharePre;

  // initialize the shared preferences
  static Future<void> init() async {
    _sharePre = await SharedPreferences.getInstance();
  }

  // save app language
  static Future<void> saveAppLanguage(String language) async {
    await _sharePre.setString('app_language', language);
  }

  // retrieve app language with default language as Khmer
  static String getAppLanguage() {
    return _sharePre.getString('app_language') ?? 'kh';
  }

  // clear the language
  static void clearAppLanguage() {
    _sharePre.remove('app_language');
  }

  static void saveDarkMode(bool isDark) {
    _sharePre.setBool('dark_mode', isDark);
  }

  static bool getDarkMode() {
    return _sharePre.getBool('dark_mode') ?? true;
  }
}
