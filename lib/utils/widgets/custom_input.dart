import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supervisor/utils/rgb.dart';

class CustomInput extends StatefulWidget {
  const CustomInput({
    this.controller,
    this.hint,
    this.formatters,
    this.onChanged,
    this.size,
    this.padding,
    super.key,
  });

  final String? hint;
  final TextEditingController? controller;
  final List<TextInputFormatter>? formatters;
  final void Function(dynamic)? onChanged;
  final double? size;
  final EdgeInsetsGeometry? padding;

  @override
  State<CustomInput> createState() => _CustomInputState();
}

class _CustomInputState extends State<CustomInput> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.size ?? 50,
      decoration: BoxDecoration(
        color: secondary.withOpacity(0.8),
        borderRadius: BorderRadius.circular(6),
      ),
      alignment: Alignment.center,
      child: Padding(
        padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 16),
        child: TextField(
          controller: widget.controller,
          inputFormatters: widget.formatters ?? [],
          decoration: InputDecoration(
            contentPadding: EdgeInsets.zero,
            border: InputBorder.none,
            hintText: widget.hint,
            hintStyle: TextStyle(
              color: dark.withOpacity(0.5),
            ),
          ),
          cursorHeight: 20,
          onChanged: widget.onChanged,
        ),
      ),
    );
  }
}
