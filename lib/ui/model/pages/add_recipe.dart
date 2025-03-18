import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:supervisor/services/http_service.dart';
import 'package:supervisor/ui/model/providers/model_details_provider.dart';
import 'package:supervisor/utils/themes/app_colors.dart';
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

  List items = [];
  List selectedItems = [];

  bool _isLoading = false;

  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    setState(() {});
  }

  Future<void> getItems() async {
    isLoading = true;

    var res = await HttpService.get(item);
    if (res['status'] == Result.success) {
      items = res['data'];
    }

    isLoading = false;
  }

  Future<void> initialize() async {
    await getItems();
    if (recipe.isNotEmpty) {
      selectedItems.add({
        "item": recipe['item'],
        "quantity": TextEditingController(text: "${recipe['quantity']}"),
      });
      setState(() {});
    } else {
      selectedItems.add({
        "item": {},
        "quantity": TextEditingController(),
      });
    }
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
        width: 600,
        maxHeight: MediaQuery.of(context).size.height - 100,
        child: Column(
          children: [
            Text(
              "Retsept${recipe.isNotEmpty ? 'ni o\'zgartirish' : ' qo\'shish'}",
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: selectedItems.length,
                itemBuilder: (context, index) {
                  Map selectedItem = selectedItems[index];

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: CustomDropdown(
                            hint: "Mahsulotni tanlang",
                            items: items.map((item) {
                              return DropdownMenuItem(
                                enabled: recipe.isNotEmpty
                                    ? false
                                    : selectedItems.any((element) =>
                                            element['item']['id'] == item['id'])
                                        ? false
                                        : true,
                                value: item['id'],
                                child: Text(
                                  item['name'],
                                  style: TextStyle(fontSize: 14),
                                ),
                              );
                            }).toList(),
                            value: selectedItem['item']?['id'],
                            onChanged: (value) {
                              Map changedItem = items.firstWhereOrNull(
                                      (element) => element?['id'] == value) ??
                                  {};
                              selectedItems[index]['item'] = changedItem;
                              selectedItems[index]['quantity'].text = "";
                              setState(() {});
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 1,
                          child: CustomInput(
                            hint: "Miqdorni kiriting",
                            controller: selectedItem['quantity'],
                            formatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: SizedBox.square(
                            dimension: 50,
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: secondary.withValues(alpha: 0.8),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                recipe.isNotEmpty
                                    ? selectedItems.first?['item']?['unit']
                                            ['name'] ??
                                        ""
                                    : selectedItem['item']?['unit']?['name'] ??
                                        "",
                                style: TextStyle(
                                  color: dark.withValues(alpha: 0.5),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (recipe.isEmpty) ...[
                          if (index == selectedItems.length - 1)
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                if (selectedItems.last['item'] == null ||
                                    selectedItems.last['quantity'].text
                                        .trim()
                                        .isEmpty) {
                                  CustomSnackbars(context)
                                      .warning("Barcha maydonlarni to'ldiring");
                                  return;
                                }

                                selectedItems.add({
                                  "item": {},
                                  "quantity": TextEditingController(),
                                });
                                setState(() {});
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
                                selectedItems.removeAt(index);
                                setState(() {});
                              },
                            ),
                        ]
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () async {
                await _addRecipe();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  isLoading
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          recipe.isNotEmpty
                              ? "O'zgartirish"
                              : "Retseptni saqlash",
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addRecipe() async {
    isLoading = true;

    if (selectedItems.length == 1 &&
        (selectedItems.first['item'] == null ||
            selectedItems.first['quantity'].text.trim().isEmpty)) {
      CustomSnackbars(context).warning("Kamida 1 ta mahsulot tanlang!");
      isLoading = false;
      return;
    }

    selectedItems.removeWhere((element) =>
        element['item'] == null || element['quantity'].text.trim().isEmpty);

    if (recipe.isNotEmpty) {
      await provider.editRecipe(context: context, recipe['id'], {
        "size_id": provider.selectedSize['id'].toString(),
        "model_color_id": provider.selectedColor['id'].toString(),
        "item_id": selectedItems.first['item']['id'].toString(),
        "quantity": selectedItems.first['quantity'].text.trim(),
      });

      isLoading = false;
      Get.back();
      return;
    }

    for (var selectedItem in selectedItems) {
      await provider.addRecipe(context: context, {
        "size_id": provider.selectedSize['id'].toString(),
        "model_color_id": provider.selectedColor['id'].toString(),
        "item_id": selectedItem['item']['id'].toString(),
        "quantity": selectedItem['quantity'].text.trim(),
      });
    }

    isLoading = false;
    Get.back();
  }
}
