import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:supervisor/ui/color/provider/color_provider.dart';
import 'package:supervisor/ui/model/providers/model_provider.dart';
import 'package:supervisor/utils/rgb.dart';
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

  List<TextEditingController> colors = [
    TextEditingController(),
  ];

  @override
  void initState() {
    () async {
      if (widget.color != null) {
        colors = [
          TextEditingController(text: widget.color!['name']),
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
        width: 300,
        maxHeight: Get.height * 0.8,
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
            Expanded(
              child: GridView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  mainAxisExtent: 50,
                ),
                itemCount: colors.length,
                itemBuilder: (context, index) {
                  final controller = colors[index];

                  return Row(
                    children: [
                      Expanded(
                        child: CustomInput(
                          controller: controller,
                          hint: "Rang nomi",
                        ),
                      ),
                      if (widget.color == null) const SizedBox(width: 8),
                      if (widget.color == null)
                        if (index == colors.length - 1)
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              colors.add(TextEditingController());
                              setState(() {});
                            },
                          )
                        else
                          IconButton(
                            style: IconButton.styleFrom(
                              backgroundColor: danger.withOpacity(0.1),
                            ),
                            icon: const Icon(Icons.delete),
                            color: danger,
                            onPressed: () {
                              colors.removeAt(index);
                              setState(() {});
                            },
                          ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () async {
                if (colors.length == 1 && colors.first.text.isEmpty) {
                  CustomSnackbars(context).error("Iltimos, rang nomini kiriting");
                  return;
                }

                if (widget.color != null) {
                  await provider.updateColor(widget.color!['id'], {
                    "name": colors.first.text,
                  });
                  Get.back(result: true);
                  return;
                }

                for (var color in colors) {
                  await provider.createColor({
                    "name": color.text,
                  });
                }

                Get.back(result: true);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
