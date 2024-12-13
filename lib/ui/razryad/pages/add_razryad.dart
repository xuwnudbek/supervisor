import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supervisor/ui/color/provider/color_provider.dart';
import 'package:supervisor/ui/razryad/provider/razryad_provider.dart';
import 'package:supervisor/utils/rgb.dart';
import 'package:supervisor/utils/widgets/custom_dialog.dart';
import 'package:supervisor/utils/widgets/custom_input.dart';
import 'package:supervisor/utils/widgets/custom_snackbars.dart';

class AddRazryad extends StatefulWidget {
  const AddRazryad({
    super.key,
    required this.provider,
    this.razryad,
  });

  final RazryadProvider provider;
  final Map? razryad;

  @override
  State<AddRazryad> createState() => _AddModelState();
}

class _AddModelState extends State<AddRazryad> {
  RazryadProvider get provider => widget.provider;

  List<Map> razryads = [
    {
      "name": TextEditingController(),
      "salary": TextEditingController(),
    }
  ];

  void addRazryad() {
    if (razryads.last['name'].text.isEmpty || razryads.last['salary'].text.isEmpty) {
      CustomSnackbars(context).error("Iltimos, barcha maydonlarni to'ldiring!");
      return;
    }
    razryads.add({
      "name": TextEditingController(),
      "salary": TextEditingController(),
    });
    setState(() {});
  }

  @override
  void initState() {
    () async {
      if (widget.razryad != null) {
        razryads = [
          {
            "name": TextEditingController(text: widget.razryad!['name']),
            "salary": TextEditingController(text: widget.razryad!['salary'].toString()),
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
        width: 400,
        maxHeight: Get.height * 0.8,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Razryad qo'shish",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: razryads.length,
                itemBuilder: (context, index) {
                  final Map razryad = razryads[index];

                  return Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: CustomInput(
                          controller: razryad['name'],
                          hint: "Razryad nomi",
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 3,
                        child: CustomInput(
                          controller: razryad['salary'],
                          hint: "Summa / sekund",
                        ),
                      ),
                      if (widget.razryad == null) const SizedBox(width: 8),
                      if (widget.razryad == null)
                        if (index == razryads.length - 1)
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              addRazryad();
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
                              razryads.removeAt(index);
                              setState(() {});
                            },
                          ),
                    ],
                  ).marginOnly(bottom: 8);
                },
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () async {
                if (razryads.first['name'].text.isEmpty || razryads.first['salary'].text.isEmpty) {
                  CustomSnackbars(context).error("Iltimos, barcha maydonlarni to'ldiring!");
                  return;
                }

                if (widget.razryad != null) {
                  await provider.updateRazryad(widget.razryad!['id'], {
                    "name": razryads.first['name'].text,
                    "salary": razryads.first['salary'].text,
                  });
                  Get.back(result: true);
                  return;
                }

                for (var razryad in razryads) {
                  await provider.createRazryad({
                    "name": razryad['name'].text,
                    "salary": razryad['salary'].text,
                  });
                }

                Get.back(result: true);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.razryad != null ? "Yangilash" : "Qo'shish",
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
