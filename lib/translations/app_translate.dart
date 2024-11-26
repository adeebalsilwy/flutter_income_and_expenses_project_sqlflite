import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {};

  Future<void> loadTranslations() async {
    final en = await _loadLanguageFile('en');
    final kh = await _loadLanguageFile('kh');
    final ar = await _loadLanguageFile('ar');

    Get.addTranslations({'en': en, 'kh': kh, 'ar': ar});
  }

  Future<Map<String, String>> _loadLanguageFile(String languageCode) async {
    final String jsonString =
        await rootBundle.loadString('assets/lang/$languageCode.json');
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    return jsonMap.map((key, value) => MapEntry(key, value.toString()));
  }
}
