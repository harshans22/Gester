import 'package:flutter/material.dart';

import 'package:gester/resources/color.dart';

class AppTheme {
  static ThemeData getAppTheme() {
    return ThemeData(
      scaffoldBackgroundColor: AppColor.BG_COLOR,
      textTheme: TextTheme(
        displayLarge: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColor.PRIMARY,
           ),
        displayMedium: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColor.PRIMARY,
            height: 1),
        displaySmall: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColor.PRIMARY,
            height: 1),
        titleLarge: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppColor.GREY,
            ),
        titleMedium: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: AppColor.GREY,
            ),
        titleSmall: const TextStyle(
          fontSize: 10,
          color: AppColor.GREY,
          fontWeight: FontWeight.w400,
    
        ),
        bodyLarge: const TextStyle(fontSize: 16, color: AppColor.PRIMARY,height: 1),
        bodyMedium: const TextStyle(fontSize: 14, color: AppColor.PRIMARY,fontWeight: FontWeight.w400),
        bodySmall:
            TextStyle(fontSize: 12, color: AppColor.BLACK.withOpacity(0.4)),
      ),
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: AppColor.PRIMARY,
        onPrimary: AppColor.WHITE,
        secondary: AppColor.WHITE,
        onSecondary: AppColor.PRIMARY,
        surface: AppColor.BG_COLOR,
        onSurface: AppColor.BLACK,
        // error: Colors.red,
        // onError: Colors.red,
        background: AppColor.BG_COLOR,
        onBackground: AppColor.BLACK,
      ),
    );
  }
}
