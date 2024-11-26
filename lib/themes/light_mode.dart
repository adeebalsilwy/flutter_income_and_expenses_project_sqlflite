import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: const Color(0xFFFAFAFA), // خلفية ناعمة فاتحة
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFFFFFFFF), // شريط علوي أبيض
    elevation: 2, // ظل خفيف
    iconTheme: IconThemeData(color: Color(0xFF616161)), // لون الأيقونات الرمادي
    titleTextStyle: TextStyle(
      color: Color(0xFF424242), // نص داكن للشريط العلوي
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  ),
  colorScheme: ColorScheme.light(
    primary: const Color(0xFF81C784), // لون أساسي أخضر فاتح
    onPrimary: Colors.white, // نصوص على اللون الأساسي
    secondary: const Color(0xFFFFD54F), // لون ثانوي أصفر ناعم
    onSecondary: Colors.black87, // نصوص على اللون الثانوي
    background: const Color(0xFFFAFAFA), // خلفية عامة ناعمة
    surface: const Color(0xFFFFFFFF), // سطح أبيض ناعم
    onSurface: Colors.black87, // نصوص على الأسطح
    error: const Color(0xFFE57373), // لون أخطاء ناعم
    onError: Colors.white, // نصوص على لون الأخطاء
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Color(0xFF424242), // نصوص كبيرة داكنة قليلاً
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      color: Color(0xFF616161), // نصوص عادية رمادية داكنة
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      color: Color(0xFF757575), // نصوص ثانوية
    ),
    titleMedium: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      color: Color(0xFF424242), // عناوين رمادية داكنة
    ),
  ),
  cardTheme: CardTheme(
    color: const Color(0xFFFFFFFF), // لون الكروت أبيض ناعم
    elevation: 3, // ظل خفيف للكروت
    margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15), // تنسيق
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16), // حواف مستديرة
    ),
  ),
  buttonTheme: ButtonThemeData(
    buttonColor: const Color(0xFF81C784), // لون الأزرار الأساسي
    textTheme: ButtonTextTheme.primary,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(24), // حواف مستديرة أكثر
    ),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: const Color(0xFFFFD54F), // لون زر الإجراء العائم
    foregroundColor: Colors.black87, // لون النصوص داخل الزر
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFFF0F0F0), // لون الحقول ناعم
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey.shade400),
      borderRadius: BorderRadius.circular(12),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Color(0xFF81C784)),
      borderRadius: BorderRadius.circular(12),
    ),
    hintStyle: const TextStyle(
      color: Colors.black54, // نصوص مساعدة رمادية ناعمة
    ),
  ),
  iconTheme: const IconThemeData(
    color: Color(0xFF616161), // لون أيقونات عامة رمادية
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF81C784), // لون الأزرار المرتفعة
      foregroundColor: Colors.white, // نصوص بيضاء
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16), // حواف مستديرة للأزرار
      ),
    ),
  ),
);
