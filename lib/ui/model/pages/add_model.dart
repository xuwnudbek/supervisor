import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supervisor/ui/model/providers/model_provider.dart';
import 'package:supervisor/utils/widgets/custom_dialog.dart';
import 'package:supervisor/utils/widgets/custom_input.dart';
import 'package:supervisor/utils/widgets/custom_snackbars.dart';

class AddModel extends StatefulWidget {
  const AddModel({
    super.key,
    this.provider,
    this.model,
  });

  final ModelProvider? provider;
  final Map? model;

  @override
  State<AddModel> createState() => _AddModelState();
}

class _AddModelState extends State<AddModel> {
  final TextEditingController nameController = TextEditingController();

  List<Map<String, dynamic>> submodels = [];

  void addSubmodel() {
    if (submodels.isEmpty) {
      submodels.add({
        "controller": TextEditingController(),
        "sizes": TextEditingController(),
      });
      setState(() {});
      return;
    }

    if (submodels.last['controller'].text.isEmpty || submodels.last['sizes'].text.isEmpty) {
      CustomSnackbars(context).warning("Iltimos, barcha maydonlarni to'ldiring!");
      return;
    }

    submodels.add({
      "controller": TextEditingController(),
      "sizes": TextEditingController(),
    });
    setState(() {});
  }

  @override
  void initState() {
    () async {
      if (widget.model != null) {
        nameController.text = widget.model!['name'];
      }
      setState(() {});
    }();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomDialog(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Model qo'shish",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            CustomInput(
              controller: nameController,
              hint: "Model kodi",
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    fixedSize: const Size.fromHeight(24),
                  ),
                  onPressed: () {
                    addSubmodel();
                  },
                  child: const Row(
                    children: [
                      Icon(
                        Icons.add_rounded,
                      ),
                      SizedBox(width: 4),
                      Text("Submodel qo'shish"),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              constraints: BoxConstraints(
                maxHeight: Get.height * 0.5,
              ),
              child: ListView(
                shrinkWrap: true,
                children: [
                  ...submodels.map(
                    (submodel) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomInput(
                          controller: submodel['controller'],
                          hint: "Submodel nomi",
                        ),
                        const SizedBox(height: 8),
                        // Sizes
                        CustomInput(
                          controller: submodel['sizes'],
                          hint: "O'lchamlarni `,` orqali kiriting!",
                        ),
                        const SizedBox(height: 8),
                        const Divider(color: Colors.black),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () async {
                if (nameController.text.isEmpty) {
                  CustomSnackbars(context).warning("Iltimos, barcha maydonlarni to'ldiring!");
                  return;
                }

                final body = {
                  "name": nameController.text.trim(),
                  "submodels": [
                    for (var submodel in submodels)
                      {
                        "name": submodel['controller'].text.trim(),
                        "sizes": submodel['sizes'].text.split(", ").map((e) => int.parse(e)).toList(),
                      },
                  ],
                };

                print(body);

                if (widget.model != null) {
                  await widget.provider!.updateModel(widget.model!['id'], body).then((value) {
                    CustomSnackbars(context).success("Model muvaffaqiyatli yangilandi!");
                    Get.back();
                  });
                  return;
                }

                await widget.provider!.createModel(body).then((value) {
                  CustomSnackbars(context).success("Buyurtma muvaffaqiyatli qo'shildi!");
                  Get.back();
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.model != null ? "Yangilash" : "Qo'shish",
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
