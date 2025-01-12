import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supervisor/services/http_service.dart';
import 'package:supervisor/ui/item/provider/item_provider.dart';
import 'package:supervisor/utils/widgets/custom_dialog.dart';
import 'package:supervisor/utils/widgets/custom_dropdown.dart';
import 'package:supervisor/utils/widgets/custom_image_widget.dart';
import 'package:supervisor/utils/widgets/custom_input.dart';
import 'package:supervisor/utils/widgets/custom_snackbars.dart';

class AddItem extends StatefulWidget {
  const AddItem({
    super.key,
    this.item,
    required this.provider,
  });

  final ItemProvider provider;
  final Map? item;

  @override
  State<AddItem> createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  ItemProvider get provider => widget.provider;
  Map get item => widget.item ?? {};

  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController codeController = TextEditingController();

  Map _selectedUnit = {};
  Map get selectedUnit => _selectedUnit;
  set selectedUnit(Map value) {
    _selectedUnit = value;
    setState(() {});
  }

  Map _selectedColor = {};
  Map get selectedColor => _selectedColor;
  set selectedColor(Map value) {
    _selectedColor = value;
    setState(() {});
  }

  Map _selectedType = {};
  Map get selectedType => _selectedType;
  set selectedType(Map value) {
    _selectedType = value;
    setState(() {});
  }

  XFile? _selectedImage;
  XFile? get selectedImage => _selectedImage;
  set selectedImage(XFile? value) {
    _selectedImage = value;
    setState(() {});
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    setState(() {});
  }

  Future<void> showImagePicker() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      selectedImage = image;
    }
  }

  Future<void> initialize() async {
    if (item.isNotEmpty) {
      nameController.text = item['name'];
      priceController.text = item['price'];
      codeController.text = item['code'] ?? "";
      selectedUnit = item['unit'] ?? {};
      selectedColor = item['color'] ?? {};
      selectedType = item['type'] ?? {};
      setState(() {});
    }
  }

  void clear() {
    nameController.clear();
    priceController.clear();
    codeController.clear();
    selectedUnit = {};
    selectedColor = {};
    selectedType = {};
    selectedImage = null;
  }

  @override
  void initState() {
    initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomDialog(
        child: Column(
          children: [
            Text(
              "Material${item.isNotEmpty ? 'ni o\'zgartirish' : ' qo\'shish'}",
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 20),
            CustomInput(
              hint: "Nomi",
              controller: nameController,
            ),
            const SizedBox(height: 8),
            CustomInput(
              hint: "Narxi",
              controller: priceController,
              formatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
              ],
            ),
            const SizedBox(height: 8),
            CustomInput(
              hint: "Kodi",
              controller: codeController,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: CustomDropdown(
                    hint: "O'lchov birligi",
                    items: provider.units
                        .map((e) => DropdownMenuItem(
                              value: e['id'],
                              child: Text(e['name']),
                            ))
                        .toList(),
                    value: selectedUnit['id'],
                    onChanged: (id) {
                      selectedUnit = provider.units
                          .firstWhere((element) => element['id'] == id);
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: CustomDropdown(
                    hint: "Rang",
                    items: provider.colors
                        .map((e) => DropdownMenuItem(
                              value: e['id'],
                              child: Text(e['name']),
                            ))
                        .toList(),
                    value: selectedColor['id'],
                    onChanged: (id) {
                      selectedColor = provider.colors
                          .firstWhere((element) => element['id'] == id);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            CustomDropdown(
              hint: "Material turi",
              items: provider.itemTypes
                  .map((e) => DropdownMenuItem(
                        value: e['id'],
                        child: Text(e['name']),
                      ))
                  .toList(),
              value: selectedType['id'],
              onChanged: (id) {
                selectedType = provider.itemTypes
                    .firstWhere((element) => element['id'] == id);
              },
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (selectedImage != null)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomImageWidget(
                          image: selectedImage!.path,
                          source: Sources.file,
                        ),
                      ),
                    ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (selectedImage != null) ...[
                        IconButton(
                          onPressed: () {
                            selectedImage = null;
                          },
                          icon: Icon(
                            Icons.clear_rounded,
                          ),
                        ),
                        SizedBox(height: 4)
                      ],
                      IconButton(
                        onPressed: () {
                          showImagePicker();
                        },
                        icon: Icon(
                          selectedImage != null
                              ? Icons.replay_rounded
                              : Icons.add_rounded,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () async {
                if (provider.isLoading ||
                    provider.isCreating ||
                    provider.isUpdating) {
                  return;
                }
                if (nameController.text.isEmpty ||
                    priceController.text.isEmpty ||
                    codeController.text.isEmpty ||
                    selectedUnit.isEmpty ||
                    selectedType.isEmpty ||
                    selectedColor.isEmpty) {
                  CustomSnackbars(context)
                      .warning("Barcha maydonlarni to'ldiring");
                  return;
                }

                final body = {
                  "name": nameController.text,
                  "price": priceController.text,
                  "unit_id": selectedUnit['id'].toString(),
                  "color_id": selectedColor['id'].toString(),
                  "code": codeController.text,
                  "type_id": selectedType['id'],
                  "image": selectedImage?.path,
                }..removeWhere((key, value) => value == null);

                if (item.isNotEmpty) {
                  var res = await provider.updateItem(item['id'], body);

                  if (res['status'] == Result.success) {
                    CustomSnackbars(context).success("Material o'zgartirildi");
                    Get.back();
                  } else {
                    CustomSnackbars(context).error("Xatolik yuz berdi");
                  }
                  return;
                }

                var res = await provider.createItem(body);

                if (res['status'] == Result.success) {
                  CustomSnackbars(context).success("Material saqlandi");
                  clear();
                } else {
                  CustomSnackbars(context).error("Xatolik yuz berdi");
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  provider.isCreating || provider.isUpdating
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          ),
                        )
                      : Text(
                          item.isNotEmpty ? "O'zgartirish" : "Itemni saqlash",
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
