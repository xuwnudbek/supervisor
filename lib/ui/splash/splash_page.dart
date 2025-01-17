
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:supervisor/services/storage_service.dart';
import 'package:supervisor/ui/auth/login_page.dart';
import 'package:supervisor/ui/home_page.dart';
import 'package:supervisor/utils/themes/app_colors.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Future<void> _splashTime() async {
    await Future.delayed(const Duration(milliseconds: 0));

    String token = StorageService.read('token') ?? '';
    Map user = StorageService.read('user') ?? {};

    bool isLogged = token.isNotEmpty && user.isNotEmpty;

    if (!isLogged) {
      Get.offAll(() => const LoginPage());
    } else {
      Get.offAll(() => const HomePage());
    }
  }

  @override
  void initState() {
    super.initState();
    _splashTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 150,
          height: 150,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: secondary.withValues(alpha: 0.2),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: LoadingAnimationWidget.inkDrop(
            color: Colors.blue,
            size: 75,
          ),
        ),
      ),
    );
  }
}
