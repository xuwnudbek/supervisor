import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supervisor/ui/color/provider/color_provider.dart';
import 'package:supervisor/utils/themes/app_colors.dart';
import 'package:supervisor/utils/widgets/custom_color_picker.dart';
import 'package:supervisor/utils/widgets/custom_dialog.dart';
import 'package:supervisor/utils/widgets/custom_input.dart';
import 'package:supervisor/utils/widgets/custom_snackbars.dart';

class AddColor extends StatefulWidget {
  const AddColor({
    super.key,
    required this.provider,
    this.color,
  });

  final ColorProvider provider;
  final Map? color;

  @override
  State<AddColor> createState() => _AddModelState();
}

class _AddModelState extends State<AddColor> {
  ColorProvider get provider => widget.provider;

  List<Map> colors = [
    {
      "name": TextEditingController(),
      "hex": "",
    }
  ];

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(value) {
    setState(() {
      _isLoading = value;
    });
  }

  void addNewColor() {
    if (colors.last['name'].text.isEmpty || colors.last['hex'].isEmpty) {
      CustomSnackbars(context)
          .warning("Malumotlar to'liq kiritilganini tekshiring!");
      return;
    }

    setState(() {
      colors.add({
        "name": TextEditingController(),
        "hex": "",
      });
    });
  }

  @override
  void initState() {
    () async {
      if (widget.color != null) {
        colors = [
          {
            "name": TextEditingController(text: widget.color!['name']),
            "hex": widget.color?['hex'] ?? "ff000000",
          }
        ];
      }
      setState(() {});
    }();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomDialog(
        width: 350,
        maxHeight: MediaQuery.of(context).size.height * 0.8,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Rang qo'shish",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                mainAxisExtent: 50,
              ),
              itemCount: colors.length,
              itemBuilder: (context, index) {
                final color = colors[index];

                return Row(
                  children: [
                    Expanded(
                      child: CustomInput(
                        controller: color['name'],
                        hint: "Rang nomi",
                      ),
                    ),
                    const SizedBox(width: 8),
                    ColorPickerSquare(
                      hex: color['hex'],
                      onColorChanged: (hex) {
                        colors[index]['hex'] = hex;
                      },
                    ),
                    if (widget.color == null) ...[
                      const SizedBox(width: 8),
                      if (index == colors.length - 1)
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            addNewColor();
                          },
                        )
                      else
                        IconButton(
                          style: IconButton.styleFrom(
                            backgroundColor: danger.withValues(alpha: 0.1),
                          ),
                          icon: const Icon(Icons.delete),
                          color: danger,
                          onPressed: () {
                            colors.removeAt(index);
                            setState(() {});
                          },
                        ),
                    ]
                  ],
                );
              },
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () async {
                if (colors.length == 1 && colors.first['name'].text.isEmpty) {
                  CustomSnackbars(context)
                      .error("Iltimos, rang nomini kiriting");
                  return;
                }

                isLoading = true;

                if (widget.color != null) {
                  await provider.updateColor(widget.color!['id'], {
                    "name": colors.first['name'].text,
                    "hex": colors.first['hex'],
                  });
                  Get.back(result: true);
                  return;
                }

                for (var color in colors) {
                  if (color['name'].text.isNotEmpty &&
                      color['hex'].isNotEmpty) {
                    await provider.createColor({
                      "name": color['name'].text,
                      "hex": color['hex'],
                    });
                  }
                }

                isLoading = false;

                Get.back(result: true);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isLoading)
                    const SizedBox.square(
                      dimension: 25,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    )
                  else
                    Text(
                      widget.color != null ? "Yangilash" : "Qo'shish",
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
