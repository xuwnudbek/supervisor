import 'package:flutter/material.dart';
import 'package:supervisor/utils/themes/app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme => ThemeData(
        fontFamily: "Montserrat",
        scaffoldBackgroundColor: secondary,
        primaryColor: primary,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: secondary,
          primary: primary,
        ),
        appBarTheme: AppBarTheme(
          elevation: 20,
          shadowColor: dark.withValues(alpha: 0.2),
          backgroundColor: primary,
          foregroundColor: secondary,
          surfaceTintColor: Colors.transparent,
        ),
        iconTheme: IconThemeData(size: 20),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            backgroundColor: primary,
            foregroundColor: light,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            fixedSize: const Size.fromHeight(50),
          ),
        ),
        dividerTheme: const DividerThemeData(
          space: 0,
          thickness: 1,
          // color: primary,
        ),
        iconButtonTheme: IconButtonThemeData(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(primary.withValues(alpha: 0.1)),
            foregroundColor: WidgetStateProperty.all(primary),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(150),
              ),
            ),
          ),
        ),
        shadowColor: dark.withValues(alpha: 0.2),
        datePickerTheme: DatePickerThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        dialogTheme: DialogTheme(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        popupMenuTheme: PopupMenuThemeData(
          elevation: 5,
          textStyle: TextStyle(color: dark),
          position: PopupMenuPosition.under,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          color: light,
          surfaceTintColor: Colors.transparent,
        ),
        // useMaterial3: true,
      );
}
