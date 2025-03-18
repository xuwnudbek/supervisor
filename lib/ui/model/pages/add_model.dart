import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supervisor/ui/model/providers/model_provider.dart';
import 'package:supervisor/utils/formatters/currency_formatter.dart';
import 'package:supervisor/utils/themes/app_colors.dart';
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
  Map? get model => widget.model;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController modelRasxodController = TextEditingController();

  final TextEditingController newSubmodelController = TextEditingController();
  final TextEditingController newSizeController = TextEditingController();

  List<String> images = [];
  List<Map> submodels = [];
  List<Map> sizes = [];

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool isLoading) {
    setState(() {
      _isLoading = isLoading;
    });
  }

  @override
  void initState() {
    super.initState();
    initialize();
  }

  void initialize() {
    if (model != null) {
      nameController.text = widget.model!['name'] ?? "";
      modelRasxodController.text = widget.model!['rasxod'] ?? "";

      for (var size in (model!['sizes'] as List)) {
        sizes.add({
          "id": size['id'],
          "name": TextEditingController(text: size['name'] ?? ""),
        });
      }

      for (var submodel in (model!['submodels'] as List)) {
        submodels.add({
          "id": submodel['id'],
          "name": TextEditingController(text: submodel['name'] ?? ""),
        });
      }

      setState(() {});
    }
  }

  void addSubmodel() {
    if (newSubmodelController.text.isEmpty) {
      CustomSnackbars(context).warning("Iltimos, submodel nomini to'ldiring!");
      return;
    }

    bool hasAlready = submodels.any((el) => el['name'].text.toLowerCase() == newSubmodelController.text.toLowerCase());

    if (hasAlready) {
      CustomSnackbars(context).warning("Malumot avvaldan mavjud!");
      return;
    }

    setState(() {
      submodels.add({
        "id": null,
        "name": TextEditingController(text: newSubmodelController.text),
      });
      newSubmodelController.clear();
    });
  }

  void removeSubmodel(value) {
    setState(() {
      submodels.remove(value);
    });
  }

  void addSize() {
    if (newSizeController.text.isEmpty) {
      CustomSnackbars(context).warning("Iltimos, razmer nomini to'ldiring!");
      return;
    }

    bool hasAlready = sizes.any((el) => el['name'].text.toLowerCase() == newSizeController.text.toLowerCase());

    if (hasAlready) {
      CustomSnackbars(context).warning("Malumot avvaldan mavjud!");
      return;
    }

    setState(() {
      sizes.add({
        "id": null,
        "name": TextEditingController(text: newSizeController.text),
      });
      newSizeController.clear();
    });
  }

  void removeSize(value) {
    setState(() {
      sizes.remove(value);
    });
  }

  Future<void> showImagesPicker() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile?> pickedImages = await picker.pickMultiImage(limit: 10);

    if (pickedImages.isNotEmpty) {
      images.addAll(pickedImages.map((e) => e!.path));
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomDialog(
        width: Get.width * 0.41,
        maxHeight: MediaQuery.of(context).size.height - 150,
        child: Column(
          spacing: 8,
          children: [
            Text(
              "Model${model != null ? "ni yangilash" : " qo'shish"}",
              style: TextTheme.of(context).titleLarge,
            ),
            Row(
              spacing: 8,
              children: [
                Expanded(
                  child: CustomInput(
                    controller: nameController,
                    hint: "Model nomi",
                  ),
                ),
                Expanded(
                  child: CustomInput(
                    controller: modelRasxodController,
                    formatters: [
                      CurrencyInputFormatter(),
                    ],
                    hint: "rasxod",
                  ),
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  spacing: 16,
                  children: [
                    Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(width: 8),
                            Text(
                              "Submodellar",
                              style: TextTheme.of(context).bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          ],
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: secondary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.all(8),
                          child: Column(
                            spacing: 8,
                            children: [
                              CustomInput(
                                controller: newSubmodelController,
                                color: light,
                                hint: "submodel",
                                onEnter: () {
                                  addSubmodel();
                                },
                                onTrailingTap: () {
                                  addSubmodel();
                                },
                                trailing: Icon(
                                  Icons.add_rounded,
                                  color: success,
                                ),
                              ),
                              GridView(
                                shrinkWrap: true,
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 4,
                                  mainAxisSpacing: 4,
                                  mainAxisExtent: 50,
                                ),
                                children: [
                                  ...submodels.map((submodel) {
                                    return CustomInput(
                                      controller: submodel['name'],
                                      color: light,
                                      hint: "submodel",
                                      onTrailingTap: () {
                                        removeSubmodel(submodel);
                                      },
                                      trailing: Icon(
                                        Icons.clear_rounded,
                                        color: danger,
                                      ),
                                    );
                                  }),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(width: 8),
                            Text(
                              "O'lchamlar",
                              style: TextTheme.of(context).bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          ],
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: secondary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.all(8),
                          child: Column(
                            spacing: 8,
                            children: [
                              CustomInput(
                                controller: newSizeController,
                                color: light,
                                formatters: [
                                  FilteringTextInputFormatter.deny(RegExp(r'[a-zA-Z]')),
                                ],
                                hint: "o'lcham",
                                onEnter: () {
                                  addSize();
                                },
                                onTrailingTap: () {
                                  addSize();
                                },
                                trailing: Icon(
                                  Icons.add_rounded,
                                  color: success,
                                ),
                              ),
                              GridView(
                                shrinkWrap: true,
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4,
                                  crossAxisSpacing: 4,
                                  mainAxisSpacing: 4,
                                  mainAxisExtent: 50,
                                ),
                                children: [
                                  ...sizes.map((size) {
                                    return CustomInput(
                                      controller: size['name'],
                                      color: light,
                                      hint: "size",
                                      onTrailingTap: () {
                                        removeSize(size);
                                      },
                                      trailing: Icon(
                                        Icons.clear_rounded,
                                        color: danger,
                                      ),
                                    );
                                  }),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(width: 8),
                            Text(
                              "Rasmlar",
                              style: TextTheme.of(context).bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          ],
                        ),
                        Container(
                          width: double.infinity,
                          height: 100,
                          decoration: BoxDecoration(
                            color: secondary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: EdgeInsets.all(8),
                          child: Stack(
                            children: [
                              images.isEmpty
                                  ? Center(
                                      child: Text(
                                        "Rasm yo'q",
                                        style: TextStyle(
                                          color: Colors.black.withValues(alpha: 0.5),
                                        ),
                                      ),
                                    )
                                  : GridView.builder(
                                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 1,
                                        crossAxisSpacing: 4,
                                        mainAxisSpacing: 4,
                                      ),
                                      shrinkWrap: true,
                                      physics: const BouncingScrollPhysics(),
                                      scrollDirection: Axis.horizontal,
                                      itemCount: images.length,
                                      itemBuilder: (context, index) {
                                        return CustomImageWidget(
                                          image: images[index],
                                          source: Sources.file,
                                          fit: BoxFit.cover,
                                          onSecondaryTap: () {
                                            setState(() {
                                              images.removeAt(index);
                                            });
                                          },
                                        );
                                      },
                                    ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: GestureDetector(
                                  onTap: showImagesPicker,
                                  child: Tooltip(
                                    message: "Yangi rasm qo'shilganda\neskilari o'chib ketadi!",
                                    child: Container(
                                      width: 30,
                                      decoration: BoxDecoration(
                                        color: light,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.add_rounded,
                                          color: primary,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                await _createModel();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (provider.isCreatingModel || provider.isUpdatingModel)
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

  Future<void> _createModel() async {
    if (provider.isLoading || provider.isCreatingModel || provider.isUpdatingModel) {
      return;
    }

    if (nameController.text.isEmpty) {
      CustomSnackbars(context).warning("Iltimos, barcha maydonlarni kiriting!");
      return;
    }

    isLoading = true;

    final body = {
      "name": nameController.text.trim(),
      "rasxod": double.tryParse(modelRasxodController.text.replaceAll(",", '').trim()) ?? "0.0",
      "sizes": [
        ...sizes.map((e) => {
              "id": e['id'],
              "name": e['name'].text.trim(),
            }),
      ],
      "submodels": [
        ...submodels.map((e) => {
              "id": e['id'],
              "name": e['name'].text.trim(),
            }),
      ],
      "images": images,
    };

    debugPrint(jsonEncode(body));

    if (widget.model != null) {
      await widget.provider.updateModel(widget.model!['id'], body).then((value) {
        if (value) {
          CustomSnackbars(context).success("Model muvaffaqiyatli yangilandi!");
          Get.back(result: true);
        } else {
          CustomSnackbars(context).error("Modelni yangilashda xatolik yuz berdi!");
        }
      });

      isLoading = false;
      return;
    }

    await widget.provider.createModel(body).then((value) {
      if (value == true) {
        CustomSnackbars(context).success("Model muvaffaqiyatli qo'shildi!");
        Get.back(result: true);
        isLoading = false;
        return;
      } else {
        CustomSnackbars(context).error("Model qo'shishda xatolik yuz berdi!");
      }
      isLoading = false;
      Get.back();
    });
  }
}
