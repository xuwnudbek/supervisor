import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:supervisor/utils/rgb.dart';
import 'package:supervisor/utils/widgets/custom_dropdown.dart';

class ModelDetails extends StatefulWidget {
  const ModelDetails({
    super.key,
    required this.model,
  });

  final Map model;

  @override
  State<ModelDetails> createState() => _ModelDetailsState();
}

class _ModelDetailsState extends State<ModelDetails> {
  Map get model => widget.model;

  Map selectedSubmodel = {};
  Map selectedSize = {};
  Map selectedColor = {};

  void selectSubmodel(int value) {
    selectedSubmodel = (model['submodels'] as List).firstWhere((submodel) => submodel['id'] == value);
    selectedSize = {};
    setState(() {});
  }

  void selectSize(int value) {
    selectedSize = (selectedSubmodel['sizes'] as List).firstWhere((size) => size['id'] == value);
    selectedColor = {};
    setState(() {});
  }

  void selectColor(int value) {
    selectedColor = (selectedSize['model_colors'] as List).firstWhere((color) => color['id'] == value);
    setState(() {});
  }

  @override
  void initState() {
    inspect(model);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                          text: "Model Name: ",
                          style: TextStyle(),
                        ),
                        TextSpan(
                          text: model['name'],
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
                  if (model.isNotEmpty)
                    SizedBox(
                      width: 200,
                      child: CustomDropdown(
                        value: selectedSubmodel['id'],
                        items: (model['submodels'] as List).map((submodel) {
                          return DropdownMenuItem(
                            enabled: selectedSubmodel['id'] != submodel['id'],
                            value: submodel['id'],
                            child: Text(submodel['name']),
                          );
                        }).toList(),
                        hint: "Submodel tanlang",
                        onChanged: (value) {
                          selectSubmodel(value);
                        },
                      ),
                    ),
                  const SizedBox(width: 16),
                  if (selectedSubmodel.isNotEmpty)
                    SizedBox(
                      width: 150,
                      child: CustomDropdown(
                        value: selectedSize['id'],
                        items: (selectedSubmodel['sizes'] as List).map<DropdownMenuItem>((size) {
                          return DropdownMenuItem(
                            enabled: selectedSize['id'] != size['id'],
                            value: size['id'],
                            child: Text(size['name']),
                          );
                        }).toList(),
                        hint: "O'lcham tanlang",
                        onChanged: (value) {
                          selectSize(value);
                        },
                      ),
                    ),
                  const SizedBox(width: 16),
                  if (selectedSize.isNotEmpty)
                    SizedBox(
                      width: 150,
                      child: CustomDropdown(
                        value: selectedColor['id'],
                        items: (selectedSize['model_colors'] as List).map((color) {
                          return DropdownMenuItem(
                            enabled: selectedColor['id'] != color['id'],
                            value: color['id'],
                            child: Text(color['name']),
                          );
                        }).toList(),
                        hint: "Rang tanlang",
                        onChanged: (value) {
                          selectColor(value);
                        },
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListView(
                    children: [
                      // table -> selectedColor has recipes
                      if (selectedColor.isNotEmpty)
                        DataTable(
                          border: TableBorder.all(
                            color: dark,
                            width: 1,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          headingRowHeight: 40,
                          columnSpacing: 24,
                          columns: const [
                            DataColumn(
                              label: Text(
                                "Item Image",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                "Item Name",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                "Price",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                "Color",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                "Quantity",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                          rows: (selectedColor['recipes'] as List).map<DataRow>((recipe) {
                            return DataRow(
                              color: WidgetStateProperty.all(Colors.white),
                              cells: [
                                DataCell(
                                  Text(
                                    "${recipe['item']['image']}",
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    "${recipe['item']['name']}",
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    "${recipe['item']['price']}\$",
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    "${recipe['item']['color']['name']}",
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    "${recipe['quantity']} ${recipe['item']['unit']['name']}",
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
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