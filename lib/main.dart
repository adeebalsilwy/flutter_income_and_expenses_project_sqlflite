import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:income_expenses/routes/route_hepler.dart';
import 'package:income_expenses/utils/share_preferences.dart';
import 'package:income_expenses/utils/database_helper.dart';
import 'package:income_expenses/model/category_model.dart';
import 'themes/theme_helper.dart';
import 'translations/app_translate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharePreferencesUtils.init();

  // Initialize the database and insert default categories if necessary
  await _initializeDatabase();

  runApp(const MyApp());
}

Future<void> _initializeDatabase() async {
  final DatabaseHelper dbHelper = DatabaseHelper.instance;
  final appTranslations = AppTranslations();
  await appTranslations.loadTranslations();

  // Check if the category table has data
  final existingCategories = await dbHelper.getAllCategories();

  if (existingCategories.isEmpty) {
    // Insert default categories if none exist
    final defaultCategories = [
      Category(name: 'Food'),
      Category(name: 'Transport'),
      Category(name: 'Utilities'),
      Category(name: 'Entertainment'),
    ];
    for (var category in defaultCategories) {
      await dbHelper.insertCategory(category);
    }
    print('Default categories inserted');
  } else {
    print('Categories already exist in the database');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ThemeHelper());
    return GetBuilder<ThemeHelper>(builder: (themeHelper) {
      return GetMaterialApp(
        title: 'InCome and Expenses App',
        debugShowCheckedModeBanner: false,
        theme: themeHelper.themeData,
        translations: AppTranslations(),
        // Set the initial language here
        locale: SharePreferencesUtils.getAppLanguage() == 'ar'
            ? const Locale('ar')
            : const Locale('en'),
        // Fallback if the device's locale is not supported
        fallbackLocale: const Locale('ar'),
        initialRoute: RouteHelper.getInitial(),
        getPages: RouteHelper.listRoutes,
      );
    });
  }
}
