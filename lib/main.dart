import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supervisor/ui/splash/splash_page.dart';
import 'package:supervisor/utils/rgb.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  await GetStorage.init();
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    size: Size(1200, 700),
    center: true,
    title: "Supervisior",
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    windowButtonVisibility: true,
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runZonedGuarded(
    () => runApp(const MyApp()),
    (error, stack) {
      print("Error: $error");
      print("Stack: $stack");
    },
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Supervisior',
      theme: ThemeData(
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
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            fixedSize: const Size.fromHeight(40),
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
        useMaterial3: true,
      ),
      home: const SplashPage(),
    );
  }
}
