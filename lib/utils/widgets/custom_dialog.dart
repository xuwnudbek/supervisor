import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supervisor/utils/rgb.dart';

class CustomDialog extends StatefulWidget {
  const CustomDialog({
    this.child,
    this.width,
    this.maxHeight,
    super.key,
  });

  final Widget? child;
  final double? width;
  final double? maxHeight;

  @override
  State<CustomDialog> createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  Widget? get child => widget.child;
  double? get width => widget.width;
  double? get maxHeight => widget.maxHeight;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () {
              Get.back(result: false);
            },
            color: primary,
            icon: const Icon(Icons.close),
            tooltip: "Oynani yopish",
          ),
          const SizedBox(height: 16),
          Container(
            width: widget.width ?? 350,
            padding: const EdgeInsets.all(16),
            constraints: BoxConstraints(
              maxHeight: widget.maxHeight ?? double.infinity,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: widget.child,
          ),
        ],
      ),
    );
  }
}
