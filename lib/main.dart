import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supervisor/ui/splash/splash_page.dart';
import 'package:supervisor/utils/RGB.dart';

void main() async {
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Super Visior',
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
          backgroundColor: primary,
          foregroundColor: secondary,
          surfaceTintColor: Colors.transparent,
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            backgroundColor: primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            fixedSize: const Size.fromHeight(40),
          ),
        ),
        dividerTheme: DividerThemeData(
          space: 0,
          thickness: 1,
          color: primary,
        ),
        iconButtonTheme: IconButtonThemeData(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(primary.withOpacity(0.1)),
            foregroundColor: WidgetStateProperty.all(primary),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(150),
              ),
            ),
          ),
        ),
      ),
      home: const SplashPage(),
    );
  }
}
