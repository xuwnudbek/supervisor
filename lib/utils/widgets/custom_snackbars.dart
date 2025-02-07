import 'package:flutter/material.dart';
import 'package:supervisor/utils/themes/app_colors.dart';

class CustomSnackbars {
  final BuildContext context;

  CustomSnackbars(this.context);

  void error(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        showCloseIcon: true,
        content: Text(message),
        closeIconColor: Colors.white,
        duration: const Duration(milliseconds: 1500),
        behavior: SnackBarBehavior.floating,
        width: 300,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }

  void success(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green.withValues(alpha: .8),
        showCloseIcon: true,
        closeIconColor: Colors.white,
        content: Text(message),
        duration: const Duration(milliseconds: 1500),
        behavior: SnackBarBehavior.floating,
        width: 300,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }

  void warning(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.orange,
        content: Text(
          message,
          style: TextStyle(
            color: light,
            fontWeight: FontWeight.w600,
          ),
        ),
        showCloseIcon: true,
        closeIconColor: light,
        duration: const Duration(milliseconds: 1500),
        behavior: SnackBarBehavior.floating,
        width: 300,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      ),
    );
  }
}
