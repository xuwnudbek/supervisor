import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:supervisor/ui/model/pages/add_recipe.dart';
import 'package:supervisor/ui/model/providers/model_details_provider.dart';
import 'package:supervisor/utils/extensions/num_extension.dart';
import 'package:supervisor/utils/themes/app_colors.dart';
import 'package:supervisor/utils/widgets/custom_dropdown.dart';
import 'package:supervisor/utils/widgets/custom_image_widget.dart';
import 'package:supervisor/utils/widgets/custom_snackbars.dart';

class ModelDetails extends StatelessWidget {
  const ModelDetails({
    super.key,
    required this.modelData,
  });

  final Map modelData;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ModelDetailsProvider>(
      create: (context) => ModelDetailsProvider(modelData: modelData),
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
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  // fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: provider.modelData['name'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: SizedBox(
                              width: 100,
                              child: Column(
                                children: [
                                  if ((provider.modelData['images'] ?? [])
                                      .isEmpty)
                                    Expanded(
                                      child: Center(
                                        child: Text(
                                          "Rasm yo'q",
                                          style: TextStyle(
                                            color: Colors.black
                                                .withValues(alpha: 0.5),
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    )
                                  else if (provider.isLoading ||
                                      provider.isImageDeleting)
                                    Expanded(
                                      child: Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    )
                                  else
                                    ...(provider.modelData['images'] ?? [])
                                        .map((image) {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                            right: 8.0, bottom: 8),
                                        child: InkWell(
                                          onTap: () {
                                            Get.dialog(
                                              AlertDialog(
                                                title: const Text("Rasm"),
                                                content: const Text(
                                                    "Rostdan ham rasmni o'chirishni hohlaysizmi?"),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () => Get.back(),
                                                    child: const Text("Yo'q"),
                                                  ),
                                                  TextButton(
                                                    style: TextButton.styleFrom(
                                                        backgroundColor:
                                                            danger),
                                                    onPressed: () async {
                                                      Get.back();
                                                      await provider
                                                          .deleteImage(
                                                              image['id']);
                                                    },
                                                    child: const Text(
                                                        "Ha, albatta"),
                                                  ),
                                                ],
                                              ),
                                            ).then((value) {
                                              if (value != null) {
                                                CustomSnackbars(context).success(
                                                    "Rasm muvaffaqiyatli o'chirildi");
                                              }
                                            });
                                          },
                                          child: Badge(
                                            label: Text("X"),
                                            child: CustomImageWidget(
                                              image: image['image'],
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              children: [
                                const SizedBox(height: 16),
                                // dropdowns -> submodels, sizes, colors
                                Row(
                                  children: [
                                    if (provider.modelData.isNotEmpty)
                                      SizedBox(
                                        width: 200,
                                        child: CustomDropdown(
                                          value:
                                              provider.selectedSubmodel['id'],
                                          items:
                                              (provider.modelData['submodels']
                                                      as List)
                                                  .map((submodel) {
                                            return DropdownMenuItem(
                                              enabled: provider
                                                      .selectedSubmodel['id'] !=
                                                  submodel['id'],
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
                                    const SizedBox(width: 8),
                                    SizedBox(
                                      width: 150,
                                      child: CustomDropdown(
                                        value: provider.selectedSize['id'],
                                        items: ((provider.selectedSubmodel[
                                                    'sizes'] ??
                                                []) as List)
                                            .map<DropdownMenuItem>((size) {
                                          return DropdownMenuItem(
                                            enabled:
                                                provider.selectedSize['id'] !=
                                                    size['id'],
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
                                    const SizedBox(width: 8),
                                    // if (provider.selectedSubmodel.isNotEmpty)
                                    SizedBox(
                                      width: 150,
                                      child: CustomDropdown(
                                        value: provider.selectedColor['id'],
                                        items: ((provider.selectedSubmodel[
                                                    'model_colors'] ??
                                                []) as List)
                                            .map((color) {
                                          return DropdownMenuItem(
                                            enabled:
                                                provider.selectedColor['id'] !=
                                                    color['id'],
                                            value: color['id'],
                                            child: Text(color['color']
                                                    ?['name'] ??
                                                'Rang yo\'q'),
                                          );
                                        }).toList(),
                                        hint: "Rang tanlang",
                                        onChanged: (value) {
                                          provider.selectColor(value);
                                        },
                                      ),
                                    ),
                                    const Spacer(),
                                    IconButton(
                                      icon: const Icon(Icons.refresh),
                                      onPressed: () async {
                                        await provider.getRecipe();
                                      },
                                    ),
                                    const SizedBox(width: 16),
                                    IconButton(
                                      icon: const Icon(Icons.add),
                                      onPressed: () async {
                                        if (provider.selectedColor.isEmpty ||
                                            provider.selectedSize.isEmpty ||
                                            provider.selectedSubmodel.isEmpty) {
                                          CustomSnackbars(context).warning(
                                              "Submodel, o'lcham va rangni tanlang");
                                          return;
                                        }

                                        await Get.to(() =>
                                            AddRecipe(provider: provider));
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
                                                    color: Colors.black
                                                        .withValues(alpha: 0.5),
                                                  ),
                                                ),
                                              )
                                            : Padding(
                                                padding:
                                                    const EdgeInsets.all(16.0),
                                                child: SingleChildScrollView(
                                                    child: Table(
                                                  border: TableBorder.all(
                                                    color: dark.withAlpha(50),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  columnWidths: const <int,
                                                      TableColumnWidth>{
                                                    0: FlexColumnWidth(
                                                        1), // Adjust widths as needed
                                                    1: FlexColumnWidth(1),
                                                    2: FlexColumnWidth(3),
                                                    3: FlexColumnWidth(1),
                                                    4: FlexColumnWidth(1),
                                                    5: FlexColumnWidth(1),
                                                    6: FlexColumnWidth(1),
                                                    7: FlexColumnWidth(1),
                                                  },
                                                  defaultVerticalAlignment:
                                                      TableCellVerticalAlignment
                                                          .middle,
                                                  children: [
                                                    // Table Header Row
                                                    TableRow(
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                      children: const [
                                                        Center(
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    8.0),
                                                            child: Text(
                                                              "#",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ),
                                                        ),
                                                        Center(
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    8.0),
                                                            child: Text(
                                                              "Rasm",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ),
                                                        ),
                                                        Center(
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    8.0),
                                                            child: Text(
                                                              "Material nomi",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ),
                                                        ),
                                                        Center(
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    8.0),
                                                            child: Text(
                                                              "Narxi",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ),
                                                        ),
                                                        Center(
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    8.0),
                                                            child: Text(
                                                              "Rang",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ),
                                                        ),
                                                        Center(
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    8.0),
                                                            child: Text(
                                                              "Miqdori",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ),
                                                        ),
                                                        Center(
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    8.0),
                                                            child: Text(
                                                              "Jami narxi",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ),
                                                        ),
                                                        Center(
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    8.0),
                                                            child: Text(
                                                              "Actions",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    // Data Rows
                                                    ...provider.recipes
                                                        .map<TableRow>(
                                                            (recipe) {
                                                      return TableRow(
                                                        decoration:
                                                            const BoxDecoration(
                                                          color: Colors.white,
                                                        ),
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Center(
                                                              child: Text(
                                                                "${provider.recipes.indexOf(recipe) + 1}",
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Center(
                                                              child: SizedBox(
                                                                height: 50,
                                                                child: CustomImageWidget(
                                                                    image: recipe[
                                                                            'item']
                                                                        [
                                                                        'image']),
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Text(
                                                              "${recipe['item']['name']}",
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Center(
                                                              child: Text(
                                                                "${double.parse(recipe['item']['price']).toCurrency}\$",
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Center(
                                                              child: Text(
                                                                "${recipe['item']['color']['name']}",
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Center(
                                                              child: Text(
                                                                "${num.parse(recipe['quantity']).toCurrency} ${recipe['item']['unit']['name']}",
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Center(
                                                              child: Text(
                                                                "${(double.parse(recipe['quantity']) * double.parse(recipe['item']['price'])).toCurrency}\$",
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Center(
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  IconButton(
                                                                    icon: const Icon(
                                                                        Icons
                                                                            .edit),
                                                                    onPressed:
                                                                        () async {
                                                                      await Get.to(() => AddRecipe(
                                                                          provider:
                                                                              provider,
                                                                          recipe:
                                                                              recipe));
                                                                    },
                                                                  ),
                                                                  const SizedBox(
                                                                      width: 8),
                                                                  IconButton(
                                                                    color:
                                                                        danger,
                                                                    icon: const Icon(
                                                                        Icons
                                                                            .delete),
                                                                    onPressed:
                                                                        () async {
                                                                      await showDialog(
                                                                        context:
                                                                            context,
                                                                        builder:
                                                                            (context) {
                                                                          return AlertDialog(
                                                                            title:
                                                                                const Text("Are you sure?"),
                                                                            content:
                                                                                const Text("Do you really want to delete this item?"),
                                                                            actions: [
                                                                              TextButton(
                                                                                onPressed: () => Get.back(),
                                                                                child: const Text("Yo'q"),
                                                                              ),
                                                                              TextButton(
                                                                                style: TextButton.styleFrom(backgroundColor: danger),
                                                                                onPressed: () async {
                                                                                  Get.back();
                                                                                  await provider.deleteRecipe(context: context, recipe['id']);
                                                                                },
                                                                                child: const Text("Ha, albatta"),
                                                                              ),
                                                                            ],
                                                                          );
                                                                        },
                                                                      ).then(
                                                                          (value) {
                                                                        if (value !=
                                                                            null) {
                                                                          CustomSnackbars(context)
                                                                              .success("Recipe muvoqqiyatli o'chirildi");
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
                                                    }),
                                                  ],
                                                )),
                                              ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
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
