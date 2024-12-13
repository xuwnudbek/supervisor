import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:supervisor/ui/order/provider/add_order_provider.dart';
import 'package:supervisor/ui/order/provider/order_provider.dart';
import 'package:supervisor/utils/extensions/datetime_extension.dart';
import 'package:supervisor/utils/extensions/map_extension.dart';
import 'package:supervisor/utils/rgb.dart';
import 'package:supervisor/utils/widgets/custom_dialog.dart';
import 'package:supervisor/utils/widgets/custom_dropdown.dart';
import 'package:supervisor/utils/widgets/custom_input.dart';

class AddOrder extends StatelessWidget {
  const AddOrder({
    super.key,
    required this.orderProvider,
  });

  final OrderProvider orderProvider;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AddOrderProvider(orderProvider),
      child: Consumer<AddOrderProvider>(
        builder: (context, provider, child) {
          return Scaffold(
            body: CustomDialog(
              width: Get.width * 0.7,
              maxHeight: MediaQuery.of(context).size.height * 0.8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Buyurtma qo'shish",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Order [ name, quantity, status[active], deadline [start, end] ]
                  Row(
                    children: [
                      Expanded(
                        child: CustomInput(
                          controller: provider.orderNameController,
                          hint: "Nomi",
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: CustomInput(
                          controller: provider.orderQuantityController,
                          hint: "Miqdori",
                          formatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        // start date
                        child: TextButton(
                          style: TextButton.styleFrom(
                            fixedSize: const Size.fromHeight(50),
                            backgroundColor: Colors.grey[200],
                            foregroundColor: Colors.black,
                          ),
                          onPressed: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now().subtract(const Duration(days: 365 * 10)),
                              lastDate: provider.endDate != null ? provider.endDate! : DateTime.now().add(const Duration(days: 365 * 10)),
                            );
                            if (date != null) {
                              provider.startDate = date;
                            }
                          },
                          child: Text(
                            provider.startDate != null ? provider.startDate!.format : "Boshlanish sanasi",
                            style: TextStyle(
                              color: provider.endDate != null ? null : Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        // end date
                        child: TextButton(
                          style: TextButton.styleFrom(
                            fixedSize: const Size.fromHeight(50),
                            backgroundColor: Colors.grey[200],
                            foregroundColor: Colors.black,
                          ),
                          onPressed: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: provider.startDate != null ? provider.startDate! : DateTime.now().subtract(const Duration(days: 365 * 10)),
                              lastDate: DateTime.now().add(const Duration(days: 365 * 10)),
                            );
                            if (date != null) {
                              provider.endDate = date;
                            }
                          },
                          child: Text(
                            provider.endDate != null ? provider.endDate!.format : "Tugash sanasi",
                            style: TextStyle(
                              color: provider.endDate != null ? null : Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (provider.orderModels.isEmpty) const Divider(color: Colors.grey).marginOnly(bottom: 16.0),
                  if (provider.orderModels.isNotEmpty)
                    SizedBox(
                      width: double.infinity,
                      child: DataTable(
                        border: TableBorder.all(
                          borderRadius: BorderRadius.circular(8),
                          color: secondary,
                          width: 1.5,
                        ),
                        columns: const [
                          DataColumn(
                            headingRowAlignment: MainAxisAlignment.center,
                            label: Center(
                              child: Text("Model"),
                            ),
                          ),
                          DataColumn(
                            headingRowAlignment: MainAxisAlignment.center,
                            label: Center(
                              child: Text("Submodel"),
                            ),
                          ),
                          DataColumn(
                            headingRowAlignment: MainAxisAlignment.center,
                            label: Center(
                              child: Text("O'lchami"),
                            ),
                          ),
                          DataColumn(
                            headingRowAlignment: MainAxisAlignment.center,
                            label: Center(
                              child: Text("Rangi"),
                            ),
                          ),
                          DataColumn(
                            headingRowAlignment: MainAxisAlignment.center,
                            label: Center(
                              child: Text("Miqdori"),
                            ),
                          ),
                          DataColumn(
                            headingRowAlignment: MainAxisAlignment.center,
                            label: Center(
                              child: Text("Amallar"),
                            ),
                          ),
                        ],
                        rows: provider.orderModels.map<DataRow>((model) {
                          return DataRow(
                            cells: [
                              DataCell(
                                Center(
                                  child: Text(
                                    "${model['name']}",
                                  ),
                                ),
                              ),
                              DataCell(
                                Center(
                                  child: Text(
                                    "${model['submodel']['name']}",
                                  ),
                                ),
                              ),
                              DataCell(
                                Center(
                                  child: Text(
                                    "${model['size']['name']}",
                                  ),
                                ),
                              ),
                              DataCell(
                                Center(
                                  child: Text(
                                    "${model['model_color']['color']['name']}",
                                  ),
                                ),
                              ),
                              DataCell(
                                Center(
                                  child: Text(
                                    "${model['quantity']}",
                                  ),
                                ),
                              ),
                              DataCell(
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      style: IconButton.styleFrom(
                                        backgroundColor: danger.withOpacity(0.1),
                                      ),
                                      onPressed: () {
                                        provider.removeModelInOrder(model);
                                      },
                                      icon: Icon(
                                        Icons.delete_rounded,
                                        color: danger,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  const SizedBox(height: 16),
                  const Spacer(),
                  Row(
                    children: [
                      // dropdown model
                      Expanded(
                        child: CustomDropdown(
                          hint: "Model",
                          items: provider.models.map<DropdownMenuItem>((e) {
                            return DropdownMenuItem(
                              value: e['id'],
                              child: Text(e['name']),
                            );
                          }).toList(),
                          onChanged: (id) {
                            provider.selectedModel = provider.models.firstWhere((e) => e['id'] == id);
                          },
                          value: provider.selectedModel?['id'],
                        ),
                      ),
                      const SizedBox(width: 8),
                      // dropdown submodel
                      Expanded(
                        child: CustomDropdown(
                          hint: "Submodel",
                          items: (provider.selectedModel?['submodels'] ?? []).map<DropdownMenuItem>((subModel) {
                            return DropdownMenuItem(
                              value: subModel['id'],
                              child: Text(subModel['name']),
                            );
                          }).toList(),
                          onChanged: (id) {
                            provider.selectedSubModel = (provider.selectedModel?['submodels'] ?? []).firstWhere((e) => e['id'] == id);
                          },
                          value: provider.selectedSubModel?['id'],
                        ),
                      ),
                      const SizedBox(width: 8),
                      // dropdown size
                      Expanded(
                        child: CustomDropdown(
                          hint: "O'lcham",
                          items: (provider.selectedSubModel?['sizes'] ?? []).map<DropdownMenuItem>((size) {
                            return DropdownMenuItem(
                              value: size['id'],
                              child: Text(size['name']),
                            );
                          }).toList(),
                          onChanged: (id) {
                            provider.selectedSize = (provider.selectedSubModel?['sizes'] ?? []).firstWhere((e) => e['id'] == id);
                          },
                          value: provider.selectedSize?['id'],
                        ),
                      ),
                      const SizedBox(width: 8),
                      // dropdown color
                      Expanded(
                        child: CustomDropdown(
                          hint: "Rang",
                          items: (provider.selectedSubModel?['model_colors'] ?? []).map<DropdownMenuItem>((modelColor) {
                            return DropdownMenuItem(
                              value: modelColor['id'],
                              child: Text(modelColor['color']['name']),
                            );
                          }).toList(),
                          onChanged: (id) {
                            provider.selectedModelColor = (provider.selectedSubModel?['model_colors'] ?? []).firstWhere((e) => e['id'] == id);
                          },
                          value: provider.selectedModelColor?['id'],
                        ),
                      ),
                      const SizedBox(width: 8),
                      // add input for quantity
                      Expanded(
                        child: CustomInput(
                          controller: provider.quantityController,
                          hint: "Miqdori",
                          formatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: () {
                          if (provider.selectedModel.isNotEmptyOrNull) {
                            provider.clearDropDowns();
                          }
                        },
                        icon: Icon(
                          Icons.clear_rounded,
                          color: provider.selectedModel.isEmptyOrNull ? Colors.grey : null,
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        style: IconButton.styleFrom(
                          backgroundColor: primary,
                          foregroundColor: light,
                        ),
                        onPressed: () {
                          provider.addModelToOrder(context);
                        },
                        icon: const Icon(Icons.add_rounded),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () async {
                      await provider.createOrder(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (provider.isLoading)
                          const SizedBox.square(
                            dimension: 25,
                            child: CircularProgressIndicator(),
                          )
                        else
                          const Text("Buyurtmani qo'shish"),
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
