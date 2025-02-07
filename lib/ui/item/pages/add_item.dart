import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:supervisor/ui/item/provider/add_item_provider.dart';
import 'package:supervisor/ui/item/provider/item_provider.dart';
import 'package:supervisor/utils/widgets/custom_dialog.dart';
import 'package:supervisor/utils/widgets/custom_dropdown.dart';
import 'package:supervisor/utils/widgets/custom_image_widget.dart';
import 'package:supervisor/utils/widgets/custom_input.dart';

class AddItem extends StatelessWidget {
  final ItemProvider provider;
  final Map? item;

  const AddItem({super.key, required this.provider, this.item});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AddItemProvider(provider: provider, item: item),
      child: Consumer<AddItemProvider>(
        builder: (context, addItemProvider, child) {
          return Scaffold(
            body: CustomDialog(
              child: Column(
                children: [
                  Text(
                    "Maxsulot${item != null ? 'ni o\'zgartirish' : ' qo\'shish'}",
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 20),
                  CustomInput(hint: "Nomi", controller: addItemProvider.nameController),
                  const SizedBox(height: 8),
                  CustomInput(
                    hint: "Narxi",
                    controller: addItemProvider.priceController,
                    formatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
                  ),
                  const SizedBox(height: 8),
                  CustomInput(hint: "Kodi", controller: addItemProvider.codeController),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: CustomDropdown(
                          hint: "O'lchov birligi",
                          items: provider.units.map((e) => DropdownMenuItem(value: e['id'], child: Text(e['name']))).toList(),
                          value: addItemProvider.selectedUnit['id'],
                          onChanged: (id) {
                            addItemProvider.selectedUnit = provider.units.firstWhere((e) => e['id'] == id);
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: CustomDropdown(
                          hint: "Rang",
                          items: provider.colors.map((e) => DropdownMenuItem(value: e['id'], child: Text(e['name']))).toList(),
                          value: addItemProvider.selectedColor['id'],
                          onChanged: (id) {
                            addItemProvider.selectedColor = provider.colors.firstWhere((e) => e['id'] == id);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  CustomDropdown(
                    hint: "Maxsulot turi",
                    items: provider.itemTypes.map((e) => DropdownMenuItem(value: e['id'], child: Text(e['name']))).toList(),
                    value: addItemProvider.selectedType['id'],
                    onChanged: (id) {
                      addItemProvider.selectedType = provider.itemTypes.firstWhere((e) => e['id'] == id);
                    },
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () => addItemProvider.showImagePicker(),
                    child: Container(
                      width: double.infinity,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.all(8.0),
                      child: addItemProvider.selectedImage != null
                          ? CustomImageWidget(
                              onSecondaryTap: () {
                                addItemProvider.selectedImage = null;
                                print("Image cleared");
                              },
                              image: addItemProvider.selectedImage!.path,
                              source: Sources.file,
                            )
                          : const Center(
                              child: Icon(
                                Icons.image_rounded,
                                color: Colors.grey,
                                size: 40,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () => addItemProvider.saveItem(context),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(item != null ? "O'zgartirish" : "Maxsulotni saqlash"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
