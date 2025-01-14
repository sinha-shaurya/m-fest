import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryColor = Color(0xFF880E4F);
  static const Color accentColor = Colors.amber;
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color textColor = Colors.black87;
  static const Color errorColor = Colors.redAccent;
  static const Color buttonTextColor = Colors.white;
}

class AppTextStyles {
  static const TextStyle heading = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryColor,
  );

  static const TextStyle subheading = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textColor,
  );

  static const TextStyle bodyText = TextStyle(
    fontSize: 14,
    color: AppColors.textColor,
  );

  static const TextStyle buttonText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.buttonTextColor,
  );

  static const TextStyle linkText = TextStyle(
    fontSize: 14,
    color: AppColors.primaryColor,
    decoration: TextDecoration.underline,
  );
}

// Define app theme
ThemeData appTheme(BuildContext context) {
  return ThemeData(
    primaryColor: AppColors.primaryColor,
    scaffoldBackgroundColor: AppColors.backgroundColor,
    textTheme: const TextTheme(
      headlineLarge: AppTextStyles.heading,
      headlineSmall: AppTextStyles.subheading,
      bodyMedium: AppTextStyles.bodyText,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: AppColors.primaryColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: AppColors.primaryColor, width: 2.0),
      ),
      labelStyle: const TextStyle(color: AppColors.primaryColor),
    ),
  );
}
