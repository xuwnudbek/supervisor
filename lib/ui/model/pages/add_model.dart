import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supervisor/ui/model/providers/model_provider.dart';
import 'package:supervisor/utils/rgb.dart';
import 'package:supervisor/utils/widgets/custom_dialog.dart';
import 'package:supervisor/utils/widgets/custom_image_widget.dart';
import 'package:supervisor/utils/widgets/custom_input.dart';
import 'package:supervisor/utils/widgets/custom_snackbars.dart';

class AddModel extends StatefulWidget {
  const AddModel({
    super.key,
    required this.provider,
    this.model,
  });

  final ModelProvider provider;
  final Map? model;

  @override
  State<AddModel> createState() => _AddModelState();
}

class _AddModelState extends State<AddModel> {
  ModelProvider get provider => widget.provider;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController modelRasxodController = TextEditingController();

  List<String> images = [];
  List<Map<String, dynamic>> submodels = [];

  void addSubmodel() {
    if (nameController.text.isEmpty) {
      CustomSnackbars(context).warning("Iltimos, model nomini to'ldiring!");
      return;
    }

    if (submodels.isEmpty) {
      submodels.add({
        "controller": TextEditingController(),
        "sizes": TextEditingController(),
        "colors": [],
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
      "colors": [],
    });
    setState(() {});
  }

  Future<void> showImagesPicker() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile?> pickedImages = await picker.pickMultiImage(limit: 10);

    if (pickedImages.isNotEmpty) {
      images = pickedImages.map((e) => e!.path).toList();
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    initialize();
  }

  void initialize() {
    if (widget.model != null) {
      nameController.text = widget.model!['name'];
      modelRasxodController.text = widget.model!['rasxod'] ?? "";
      for (var submodel in widget.model!['submodels']) {
        submodels.add({
          "controller": TextEditingController(text: submodel['name']),
          "sizes": TextEditingController(text: (submodel['sizes'].map((e) => e['name'])).join(",")),
          "colors": submodel['model_colors'].map((e) => e['color']['id']).toList(),
        });
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomDialog(
        width: Get.width * 0.4,
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
            Row(
              children: [
                Expanded(
                  child: CustomInput(
                    controller: nameController,
                    hint: "Model kodi",
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: CustomInput(
                    controller: modelRasxodController,
                    formatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                    ],
                    hint: "Model uchun rasxod",
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.5,
              ),
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: submodels.length,
                  itemBuilder: (context, index) {
                    Map submodel = submodels[index];

                    return Container(
                      decoration: BoxDecoration(
                        color: secondary.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.all(8.0),
                      margin: const EdgeInsets.only(bottom: 4),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: CustomInput(
                                  controller: submodel['controller'],
                                  hint: "Submodel nomi",
                                  color: light,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: CustomInput(
                                  controller: submodel['sizes'],
                                  hint: "O'lchamlarni `,` orqali kiriting!",
                                  color: light,
                                  formatters: [
                                    FilteringTextInputFormatter.allow(RegExp(r'[0-9,]')),
                                    TextInputFormatter.withFunction((oldValue, newValue) {
                                      if (newValue.text.contains(",,")) {
                                        return oldValue;
                                      }
                                      return newValue;
                                    }),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: Get.width * 0.4,
                            decoration: BoxDecoration(
                              color: light,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            padding: const EdgeInsets.all(8),
                            child: SingleChildScrollView(
                              child: Wrap(
                                runSpacing: 8,
                                spacing: 8,
                                children: [
                                  ...provider.colors.map((color) {
                                    bool isSelected = submodel['colors']?.contains(color['id']) ?? false;

                                    return ChoiceChip(
                                      backgroundColor: secondary,
                                      surfaceTintColor: Colors.transparent,
                                      selectedColor: primary,
                                      label: Text(color['name']),
                                      selected: isSelected,
                                      onSelected: (value) {
                                        if (value) {
                                          submodel['colors'].add(color['id']);
                                        } else {
                                          submodel['colors'].remove(color['id']);
                                        }
                                        setState(() {});
                                      },
                                    );
                                  }),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  }),
            ),
            const SizedBox(height: 8),
            if (widget.model == null)
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
            const SizedBox(height: 8),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.grey[200],
                fixedSize: const Size.fromHeight(100),
                backgroundBuilder: (BuildContext context, child, Widget? background) {
                  return Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[200]!),
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: images.isNotEmpty
                        ? ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: images.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                child: InkWell(
                                  onTap: () {
                                    images.removeAt(index);
                                    setState(() {});
                                  },
                                  child: Badge(
                                    label: const Text("X"),
                                    child: CustomImageWidget(
                                      image: images[index],
                                      source: Sources.file,
                                    ),
                                  ),
                                ),
                              );
                            },
                          )
                        : const Icon(
                            Icons.image,
                            color: Colors.grey,
                          ),
                  );
                },
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.image,
                    color: Colors.grey,
                  ),
                ],
              ),
              onPressed: () async {
                await showImagesPicker();
              },
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () async {
                if (provider.isLoading || provider.isCreatingModel || provider.isUpdatingModel) return;

                if (nameController.text.isEmpty || submodels.any((element) => element['controller'].text.isEmpty || element['sizes'].text.isEmpty)) {
                  CustomSnackbars(context).warning("Iltimos, barcha maydonlarni to'ldiring!");
                  return;
                }

                final body = {
                  "name": nameController.text.trim(),
                  "rasxod": double.tryParse(modelRasxodController.text.trim()) ?? 0.0,
                  "images": images,
                  "submodels": [
                    for (var submodel in submodels)
                      {
                        "name": submodel['controller'].text.trim(),
                        "sizes": submodel['sizes'].text.trim().split(",").map((e) {
                          return int.tryParse(e) ?? 0;
                        }).toList()
                          ..removeWhere((element) => element == 0),
                        "colors": submodel['colors'],
                      },
                  ],
                };

                if (widget.model != null) {
                  await widget.provider.updateModel(widget.model!['id'], body).then((value) {
                    CustomSnackbars(context).success("Model muvaffaqiyatli yangilandi!");
                    Get.back();
                  });
                  return;
                }

                await widget.provider.createModel(body).then((value) {
                  CustomSnackbars(context).success("Buyurtma muvaffaqiyatli qo'shildi!");
                  Get.back();
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (provider.isLoading || provider.isCreatingModel || provider.isUpdatingModel)
                    const SizedBox.square(
                      dimension: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  else
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
