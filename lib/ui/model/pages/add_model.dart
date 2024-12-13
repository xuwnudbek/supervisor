import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supervisor/ui/model/providers/model_provider.dart';
import 'package:supervisor/utils/rgb.dart';
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
        for (var submodel in widget.model!['submodels']) {
          submodels.add({
            "controller": TextEditingController(text: submodel['name']),
            "sizes": TextEditingController(text: (submodel['sizes'].map((e) => e['name'])).join(",")),
          });
        }
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
            const SizedBox(height: 16),
            if (widget.model?['submodels'] != null)
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: secondary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "Submodellar",
                    style: TextStyle(
                      color: dark.withOpacity(.7),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Divider(
                      color: secondary,
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
                      children: [
                        CustomInput(
                          controller: submodel['controller'],
                          hint: "Submodel nomi",
                          color: secondary.withOpacity(0.8),
                        ),
                        const SizedBox(height: 2),
                        CustomInput(
                          controller: submodel['sizes'],
                          hint: "O'lchamlarni `,` orqali kiriting!",
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Divider(color: secondary),
                ),
                const SizedBox(width: 4),
                IconButton(
                  tooltip: "Submodel qo'shish",
                  onPressed: () {
                    addSubmodel();
                  },
                  icon: const Icon(Icons.add_rounded),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Divider(color: secondary),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () async {
                if (nameController.text.isEmpty || submodels.any((element) => element['controller'].text.isEmpty || element['sizes'].text.isEmpty)) {
                  CustomSnackbars(context).warning("Iltimos, barcha maydonlarni to'ldiring!");
                  return;
                }

                final body = {
                  "name": nameController.text.trim(),
                  "submodels": [
                    for (var submodel in submodels)
                      {
                        "name": submodel['controller'].text.trim(),
                        "sizes": submodel['sizes'].text.trim().split(",").map((e) {
                          return int.tryParse(e) ?? 0;
                        }).toList()
                          ..removeWhere((element) => element == 0),
                      },
                  ],
                };

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
