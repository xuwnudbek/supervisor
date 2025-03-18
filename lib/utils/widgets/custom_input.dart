import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supervisor/utils/themes/app_colors.dart';

class CustomInput extends StatefulWidget {
  const CustomInput({
    this.controller,
    this.hint,
    this.enabled,
    this.textAlign,
    this.tooltip,
    this.formatters,
    this.onChanged,
    this.size,
    this.padding,
    this.color,
    this.focusNode,
    this.trailing,
    this.onTrailingTap,
    this.onEnter,
    this.lines,
    this.borderRadius,
    super.key,
  });

  final String? hint;
  final TextAlign? textAlign;
  final String? tooltip;
  final bool? enabled;
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final List<TextInputFormatter>? formatters;
  final void Function(dynamic)? onChanged;
  final double? size;
  final int? lines;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final Widget? trailing;
  final Function? onTrailingTap;
  final Function? onEnter;
  final BorderRadius? borderRadius;

  @override
  State<CustomInput> createState() => _CustomInputState();
}

class _CustomInputState extends State<CustomInput> {
  bool _hasHover = false;
  bool _hasFocus = false;

  bool get hasHover => _hasHover;
  set hasHover(value) {
    setState(() {
      _hasHover = value;
    });
  }

  bool get hasFocus => _hasFocus;
  set hasFocus(value) {
    setState(() {
      _hasFocus = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip ?? "",
      child: Container(
        height: widget.size ?? 50,
        decoration: BoxDecoration(
          border: Border.all(
            width: 0.1,
            color: Colors.transparent,
          ),
          color: widget.color ?? secondary.withValues(alpha: 0.8),
          borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 1),
        child: Row(
          spacing: 8,
          children: [
            Expanded(
              child: TextFormField(
                enabled: widget.enabled ?? true,
                focusNode: widget.focusNode, // Fokus tugmasi ulandi
                controller: widget.controller,
                inputFormatters: widget.formatters ?? [],
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) {
                  widget.onEnter?.call();
                  widget.focusNode?.requestFocus();
                },
                textAlign: widget.textAlign ?? TextAlign.start,
                cursorWidth: 1,
                maxLines: widget.lines ?? 1,
                style: TextStyle(
                  overflow: TextOverflow.ellipsis,
                ),
                decoration: InputDecoration(
                  floatingLabelAlignment: FloatingLabelAlignment.start,
                  contentPadding: widget.padding ?? EdgeInsets.symmetric(horizontal: 16, vertical: 0.0),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Colors.grey.shade200,
                    ),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Colors.grey.shade200,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: primary,
                      width: 1.5,
                    ),
                  ),
                  focusColor: primary,
                  hoverColor: primary,
                  hintText: widget.hint,
                  hintStyle: TextStyle(
                    color: dark.withValues(alpha: 0.35),
                  ),
                ),
                cursorHeight: 20,
                onChanged: widget.onChanged,
              ),
            ),
            if (widget.trailing != null)
              Padding(
                padding: EdgeInsets.only(right: 8),
                child: InkWell(
                  radius: 100,
                  onTap: () {
                    widget.onTrailingTap?.call();
                  },
                  child: SizedBox.square(
                    dimension: 24,
                    child: widget.trailing!,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
