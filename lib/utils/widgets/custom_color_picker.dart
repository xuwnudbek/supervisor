import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';
import 'package:supervisor/utils/extensions/color_extension.dart';
import 'package:supervisor/utils/themes/app_colors.dart';
import '../extensions/string_extension.dart';

class ColorPickerSquare extends StatefulWidget {
  const ColorPickerSquare({
    super.key,
    required this.hex,
    required this.onColorChanged,
  });

  final String hex;
  final void Function(String) onColorChanged;

  @override
  State<ColorPickerSquare> createState() => _ColorPickerSquareState();
}

class _ColorPickerSquareState extends State<ColorPickerSquare> {
  String get hex => widget.hex;

  late String _selectedHEX;
  String get selectedHEX => _selectedHEX;
  set selectedHEX(String value) {
    _selectedHEX = value;
    setState(() {});
  }

  @override
  void initState() {
    if (hex.isNotEmpty) {
      selectedHEX = hex;
    } else {
      selectedHEX = "ffffff";
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Rangni tanlang"),
              content: SingleChildScrollView(
                child: ColorPicker(
                  pickerColor: selectedHEX.toHEXColor,
                  hexInputBar: true,
                  // displayThumbColor: true,
                  onColorChanged: (color) {
                    selectedHEX = color.toHEX;
                  },
                  paletteType: PaletteType.hueWheel,
                  pickerAreaHeightPercent: 1.0,
                  enableAlpha: false,
                  portraitOnly: true,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    widget.onColorChanged.call(selectedHEX);
                    Get.back();
                  },
                  child: const Text("Tasdiqlash"),
                ),
              ],
            );
          },
        );
      },
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          border: Border.all(color: secondary),
          color: selectedHEX.toHEXColor,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
