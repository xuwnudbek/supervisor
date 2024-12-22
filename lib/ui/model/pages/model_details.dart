import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:supervisor/ui/model/pages/add_recipe.dart';
import 'package:supervisor/ui/model/providers/model_details_provider.dart';
import 'package:supervisor/utils/rgb.dart';
import 'package:supervisor/utils/widgets/custom_dropdown.dart';
import 'package:supervisor/utils/widgets/custom_snackbars.dart';

class ModelDetails extends StatelessWidget {
  const ModelDetails({
    super.key,
    required this.model,
  });

  final Map model;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ModelDetailsProvider>(
      create: (context) => ModelDetailsProvider(model: model),
      child: Consumer<ModelDetailsProvider>(
        builder: (context, provider, _) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Model Details"),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text.rich(
                          TextSpan(
                            children: [
                              const TextSpan(
                                text: "Model: ",
                              ),
                              TextSpan(
                                text: provider.model['name'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // dropdowns -> submodels, sizes, colors
                    Row(
                      children: [
                        if (provider.model.isNotEmpty)
                          SizedBox(
                            width: 200,
                            child: CustomDropdown(
                              value: provider.selectedSubmodel['id'],
                              items: (provider.model['submodels'] as List).map((submodel) {
                                return DropdownMenuItem(
                                  enabled: provider.selectedSubmodel['id'] != submodel['id'],
                                  value: submodel['id'],
                                  child: Text(submodel['name']),
                                );
                              }).toList(),
                              hint: "Submodel tanlang",
                              onChanged: (value) {
                                provider.selectSubmodel(value);
                              },
                            ),
                          ),
                        const SizedBox(width: 16),
                        if (provider.selectedSubmodel.isNotEmpty)
                          SizedBox(
                            width: 150,
                            child: CustomDropdown(
                              value: provider.selectedSize['id'],
                              items: ((provider.selectedSubmodel['sizes'] ?? []) as List).map<DropdownMenuItem>((size) {
                                return DropdownMenuItem(
                                  enabled: provider.selectedSize['id'] != size['id'],
                                  value: size['id'],
                                  child: Text(size['name']),
                                );
                              }).toList(),
                              hint: "O'lcham tanlang",
                              onChanged: (value) {
                                provider.selectSize(value);
                              },
                            ),
                          ),
                        const SizedBox(width: 16),
                        if (provider.selectedSubmodel.isNotEmpty)
                          SizedBox(
                            width: 150,
                            child: CustomDropdown(
                              value: provider.selectedColor['id'],
                              items: ((provider.selectedSubmodel['model_colors'] ?? []) as List).map((color) {
                                return DropdownMenuItem(
                                  enabled: provider.selectedColor['id'] != color['id'],
                                  value: color['id'],
                                  child: Text(color['color']?['name'] ?? 'Rang yo\'q'),
                                );
                              }).toList(),
                              hint: "Rang tanlang",
                              onChanged: (value) {
                                provider.selectColor(value);
                              },
                            ),
                          ),

                        // refresh, add icon buttons
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.refresh),
                          onPressed: () async {
                            await provider.getModel();
                          },
                        ),
                        const SizedBox(width: 16),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () async {
                            await Get.to(() => AddRecipe(provider: provider));
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: secondary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: provider.isLoading
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : provider.recipes.isEmpty
                                ? Center(
                                    child: Text(
                                      "Hozircha hech qanday retsept yo'q",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black.withOpacity(0.5),
                                      ),
                                    ),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: SingleChildScrollView(
                                      child: DataTable(
                                        border: TableBorder.all(
                                          color: dark.withAlpha(50),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        headingRowHeight: 52,
                                        dataRowMaxHeight: 52,
                                        dataRowMinHeight: 52,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        columns: const [
                                          DataColumn(
                                            label: Text(
                                              "#",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            numeric: true,
                                            headingRowAlignment: MainAxisAlignment.center,
                                          ),
                                          DataColumn(
                                            label: Row(
                                              children: [
                                                Text(
                                                  "Material Image",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            headingRowAlignment: MainAxisAlignment.center,
                                          ),
                                          DataColumn(
                                            label: Row(
                                              children: [
                                                Text(
                                                  "Material Name",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            headingRowAlignment: MainAxisAlignment.center,
                                          ),
                                          DataColumn(
                                            label: Row(
                                              children: [
                                                Text(
                                                  "Price",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            headingRowAlignment: MainAxisAlignment.center,
                                          ),
                                          DataColumn(
                                            label: Row(
                                              children: [
                                                Text(
                                                  "Color",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            headingRowAlignment: MainAxisAlignment.center,
                                          ),
                                          DataColumn(
                                            label: Row(
                                              children: [
                                                Text(
                                                  "Quantity",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            headingRowAlignment: MainAxisAlignment.center,
                                          ),
                                          DataColumn(
                                            label: Row(
                                              children: [
                                                Text(
                                                  "Total Price",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            headingRowAlignment: MainAxisAlignment.center,
                                          ),
                                          DataColumn(
                                            label: Row(
                                              children: [
                                                Text(
                                                  "Actions",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            headingRowAlignment: MainAxisAlignment.center,
                                          ),
                                        ],
                                        rows: provider.recipes.map<DataRow>((recipe) {
                                          return DataRow(
                                            cells: [
                                              DataCell(
                                                Center(
                                                  child: Text(
                                                    "${provider.recipes.indexOf(recipe) + 1}",
                                                  ),
                                                ),
                                              ),
                                              DataCell(
                                                Center(
                                                  child: SizedBox.square(
                                                    dimension: 50,
                                                    child: true
                                                        ? const Text("Rasm yo'q")
                                                        : recipe['item']['image'].toString().contains("images")
                                                            ? Image.network(
                                                                "http://176.124.208.61:2005/storage/${recipe['item']['image']}",
                                                                frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                                                                  return ClipRRect(
                                                                    borderRadius: BorderRadius.circular(8),
                                                                    child: child,
                                                                  );
                                                                },
                                                                loadingBuilder: (context, child, loadingProgress) {
                                                                  if (loadingProgress == null) {
                                                                    return child;
                                                                  } else {
                                                                    return const SizedBox.square(
                                                                      dimension: 50,
                                                                      child: Center(
                                                                        child: CircularProgressIndicator(),
                                                                      ),
                                                                    );
                                                                  }
                                                                },
                                                              )
                                                            : 3 > 2
                                                                ? const SizedBox.shrink()
                                                                : Image.network(
                                                                    "http://176.124.208.61:2025/media/${recipe['item']['image']}",
                                                                    frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                                                                      return ClipRRect(
                                                                        borderRadius: BorderRadius.circular(8),
                                                                        child: child,
                                                                      );
                                                                    },
                                                                    loadingBuilder: (context, child, loadingProgress) {
                                                                      if (loadingProgress == null) {
                                                                        return child;
                                                                      } else {
                                                                        return const SizedBox.square(
                                                                          dimension: 50,
                                                                          child: Center(
                                                                            child: CircularProgressIndicator(),
                                                                          ),
                                                                        );
                                                                      }
                                                                    },
                                                                  ),
                                                  ),
                                                ),
                                              ),
                                              DataCell(
                                                Center(
                                                  child: Text(
                                                    "${recipe['item']['name']}",
                                                  ),
                                                ),
                                              ),
                                              DataCell(
                                                Center(
                                                  child: Text(
                                                    "${recipe['item']['price']}\$",
                                                  ),
                                                ),
                                              ),
                                              DataCell(
                                                Center(
                                                  child: Text(
                                                    "${recipe['item']['color']['name']}",
                                                  ),
                                                ),
                                              ),
                                              DataCell(
                                                Center(
                                                  child: Text(
                                                    "${recipe['quantity']} ${recipe['item']['unit']['name']}",
                                                  ),
                                                ),
                                              ),
                                              DataCell(
                                                Center(
                                                  child: Text(
                                                    "${double.parse("${double.parse(recipe['quantity']) * (double.parse(recipe['item']['price']))}").toStringAsFixed(2)}\$",
                                                  ),
                                                ),
                                              ),
                                              DataCell(
                                                Center(
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      IconButton(
                                                        icon: const Icon(Icons.edit),
                                                        onPressed: () async {
                                                          await Get.to(() => AddRecipe(provider: provider, recipe: recipe));
                                                        },
                                                      ),
                                                      const SizedBox(width: 8),
                                                      IconButton(
                                                        style: ButtonStyle(
                                                          backgroundColor: WidgetStateProperty.all(danger.withOpacity(0.1)),
                                                        ),
                                                        color: danger,
                                                        icon: const Icon(Icons.delete),
                                                        onPressed: () async {
                                                          await showDialog(
                                                            context: context,
                                                            builder: (context) {
                                                              return AlertDialog(
                                                                title: const Text("Are you sure?"),
                                                                content: const Text("Do you really want to delete this item?"),
                                                                actions: [
                                                                  TextButton(
                                                                    onPressed: () {
                                                                      Get.back();
                                                                    },
                                                                    child: const Text("No"),
                                                                  ),
                                                                  TextButton(
                                                                    style: TextButton.styleFrom(
                                                                      backgroundColor: danger,
                                                                    ),
                                                                    onPressed: () async {
                                                                      Get.back();
                                                                      await provider.deleteRecipe(recipe['id']);
                                                                    },
                                                                    child: const Text("Yes"),
                                                                  ),
                                                                ],
                                                              );
                                                            },
                                                          ).then((value) {
                                                            if (value != null) {
                                                              CustomSnackbars(context).success("Recipe muvoqqiyatli o'chirildi");
                                                            }
                                                          });
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/*
{
  "id": 1,
  "quantity": 4,
  "item": {
    "id": 6,
    "name": "Bugunok",
    "price": "0.9",
    "image": null,
    "unit": {
      "id": 1,
      "name": "Metr",
      "created_at": "2024-12-06T16:35:41.000000Z",
      "updated_at": "2024-12-06T16:35:41.000000Z"
    },
    "color": {
      "id": 7,
      "name": "Oq"
    }
  }
},
*/
