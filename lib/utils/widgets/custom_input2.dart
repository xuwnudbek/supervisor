import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supervisor/utils/themes/app_colors.dart';
import 'package:supervisor/utils/widgets/custom_input.dart';

class CustomDropdown2 extends StatefulWidget {
  const CustomDropdown2({
    this.width,
    this.searchController,
    this.hint,
    this.tooltip,
    this.items,
    this.disabledItems,
    this.onChanged,
    this.onTapTrailing,
    this.value,
    this.size,
    this.borderRadius,
    this.color,
    super.key,
  });

  final double? width;
  final String? hint;
  final TextEditingController? searchController;
  final String? tooltip;
  final List<DropdownMenuItem>? items;
  final List? disabledItems;
  final dynamic value;
  final void Function(dynamic)? onChanged;
  final void Function()? onTapTrailing;
  final double? size;
  final BorderRadius? borderRadius;
  final Color? color;

  @override
  State<CustomDropdown2> createState() => _CustomDropdown2State();
}

class _CustomDropdown2State extends State<CustomDropdown2> {
  String _searchText = "";
  String get searchText => _searchText;
  set searchText(String value) {
    _searchText = value;
    setState(() {});
  }

  List<DropdownMenuItem> get filteredItems {
    return (widget.items ?? []).where((item) {
      return (item.child as Text).data.toString().toLowerCase().contains(searchText.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CustomInput2Provider>(builder: (context, provider, _) {
      return Container(
        width: widget.width,
        height: widget.size ?? 50,
        decoration: BoxDecoration(
          color: widget.color ?? secondary.withValues(alpha: 0.8),
          borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: DropdownButtonHideUnderline(
            child: DropdownButton(
              padding: EdgeInsets.zero,
              menuMaxHeight: 300,
              isExpanded: true,
              items: [
                DropdownMenuItem(
                  enabled: false,
                  child: CustomInput(
                    controller: TextEditingController(text: searchText),
                    hint: "Qidirish",
                    onChanged: (p0) {
                      searchText = p0;
                    },
                    size: 50,
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                  ),
                ),
                ...filteredItems.map((e) {
                  return DropdownMenuItem(
                    value: e.value,
                    child: e.child,
                  );
                }),
              ],
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
      );
    });
  }
}

class CustomInput2Provider extends ChangeNotifier {}
