import 'package:flutter/material.dart';
import 'package:supervisor/utils/themes/app_colors.dart';

class CustomDropdown extends StatefulWidget {
  const CustomDropdown({
    this.width,
    this.hint,
    this.tooltip,
    this.items,
    this.disabledItems,
    this.onChanged,
    this.value,
    this.size,
    this.color,
    super.key,
  });

  final double? width;
  final String? hint;
  final String? tooltip;
  final List<DropdownMenuItem>? items;
  final List? disabledItems;
  final dynamic value;
  final void Function(dynamic)? onChanged;
  final double? size;
  final Color? color;

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip ?? "",
      child: Container(
        width: widget.width,
        height: widget.size ?? 50,
        decoration: BoxDecoration(
          color: widget.color ?? secondary.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: DropdownButtonHideUnderline(
            child: DropdownButton(
              menuMaxHeight: 300,
              isExpanded: true,
              items: widget.items,
              onChanged: (value) {
                widget.onChanged?.call(value);
              },
              value: widget.value,
              hint: Text(
                widget.hint ?? "",
                style: const TextStyle(
                  color: Colors.grey,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
