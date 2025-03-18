import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:supervisor/ui/auth/provider/auth_provider.dart';
import 'package:supervisor/ui/home_page.dart';
import 'package:supervisor/utils/themes/app_colors.dart';
import 'package:supervisor/utils/widgets/custom_input.dart';
import 'package:supervisor/utils/widgets/custom_snackbars.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuthProvider>(
      create: (context) => AuthProvider(),
      child: Consumer<AuthProvider>(
        builder: (context, provider, _) {
          return Scaffold(
            body: Center(
              child: Container(
                width: 350,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.2),
                      spreadRadius: 3,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Kirish',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: primary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    CustomInput(
                      controller: provider.loginController,
                      hint: 'Username',
                    ),
                    const SizedBox(height: 8),
                    CustomInput(
                      controller: provider.passwordController,
                      hint: 'Parol',
                    ),
                    const SizedBox(height: 24),
                    TextButton(
                      onPressed: () async {
                        if (provider.isLoading) return;
                        if (provider.loginController.text.isEmpty ||
                            provider.passwordController.text.isEmpty) {
                          CustomSnackbars(context).warning(
                            'Iltimos, login va parolni kiriting',
                          );
                          return;
                        }
                        var res = await provider.authLogin(context);
                        if (res) {
                          Get.offAll(() => const HomePage());
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: provider.isLoading
                            ? [
                                const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                ),
                              ]
                            : [
                                Icon(
                                  Icons.login,
                                  color: light,
                                ),
                                const SizedBox(width: 8),
                                const Text('Kirish'),
                              ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
