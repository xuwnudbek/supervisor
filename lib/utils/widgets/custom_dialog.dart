import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supervisor/utils/rgb.dart';

class CustomDialog extends StatefulWidget {
  const CustomDialog({
    this.child,
    this.width,
    super.key,
  });

  final Widget? child;
  final double? width;

  @override
  State<CustomDialog> createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () {
                Get.back();
              },
              color: primary,
              icon: const Icon(Icons.close),
            ),
            const SizedBox(height: 16),
            Container(
              width: widget.width ?? 350,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: widget.child,
            ),
          ],
        ),
      ),
    );
  }
}
