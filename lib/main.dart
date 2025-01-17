import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supervisor/ui/splash/splash_page.dart';
import 'package:window_manager/window_manager.dart';

import 'utils/themes/app_theme.dart';

void main() async {
  await GetStorage.init("supervisor");
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
    await windowManager.maximize();
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
      theme: AppTheme.lightTheme,
      home: const SplashPage(),
    );
  }
}
