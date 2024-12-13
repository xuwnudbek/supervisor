import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:supervisor/services/http_service.dart';
import 'package:supervisor/ui/model/providers/model_details_provider.dart';
import 'package:supervisor/utils/widgets/custom_dialog.dart';
import 'package:supervisor/utils/widgets/custom_dropdown.dart';
import 'package:supervisor/utils/widgets/custom_input.dart';
import 'package:supervisor/utils/widgets/custom_snackbars.dart';

class AddRecipe extends StatefulWidget {
  const AddRecipe({
    super.key,
    this.recipe,
    required this.provider,
  });

  final ModelDetailsProvider provider;
  final Map? recipe;

  @override
  State<AddRecipe> createState() => _AddRecipeState();
}

class _AddRecipeState extends State<AddRecipe> {
  ModelDetailsProvider get provider => widget.provider;
  Map get recipe => widget.recipe ?? {};

  final TextEditingController quantityController = TextEditingController();
  Map selectedItem = {};

  List items = [];

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    setState(() {});
  }

  Future<void> getItems() async {
    isLoading = true;

    var res = await HttpService.get(item);
    inspect(res);
    if (res['status'] == Result.success) {
      items = res['data'];
    }

    isLoading = false;
  }

  Future<void> initialize() async {
    if (recipe.isNotEmpty) {
      selectedItem = recipe['item'] ?? {};
      quantityController.text = recipe['quantity'].toString();
      setState(() {});
    }
    await getItems();
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
              "Retsept${recipe.isNotEmpty ? 'ni o\'zgartirish' : ' qo\'shish'}",
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: CustomDropdown(
                    hint: "Mahsulotni tanlang",
                    items: items.map((item) {
                      return DropdownMenuItem(
                        enabled: recipe.isEmpty,
                        value: item['id'],
                        child: Text(item['name']),
                      );
                    }).toList(),
                    value: selectedItem['id'],
                    onChanged: (value) {
                      selectedItem = items.firstWhere((item) => item['id'] == value);
                      setState(() {});
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: CustomInput(
                    hint: "Miqdorni kiriting",
                    controller: quantityController,
                    formatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () async {
                if (selectedItem.isEmpty || quantityController.text.isEmpty) {
                  CustomSnackbars(context).warning("Barcha maydonlarni to'ldiring");
                  return;
                }

                if (recipe.isNotEmpty) {
                  var res = await provider.editRecipe(recipe['id'], {
                    "size_id": provider.selectedSize['id'].toString(),
                    "model_color_id": provider.selectedColor['id'].toString(),
                    "item_id": selectedItem['id'].toString(),
                    "quantity": quantityController.text.trim(),
                  });

                  Get.back();
                  return;
                }

                var res = await provider.addRecipe({
                  "size_id": provider.selectedSize['id'].toString(),
                  "model_color_id": provider.selectedColor['id'].toString(),
                  "item_id": selectedItem['id'].toString(),
                  "quantity": quantityController.text.trim(),
                });

                Get.back();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    recipe.isNotEmpty ? "O'zgartirish" : "Retseptni saqlash",
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
