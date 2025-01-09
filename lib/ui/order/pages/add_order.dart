import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:supervisor/ui/order/provider/add_order_provider.dart';
import 'package:supervisor/ui/order/provider/order_provider.dart';
import 'package:supervisor/utils/extensions/datetime_extension.dart';
import 'package:supervisor/utils/extensions/map_extension.dart';
import 'package:supervisor/utils/extensions/num_extension.dart';
import 'package:supervisor/utils/extensions/string_extension.dart';
import 'package:supervisor/utils/formatters/currency_formatter.dart';
import 'package:supervisor/utils/rgb.dart';
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
        builder: (context, provider, _) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Buyurtma qo'shish"),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Flexible(
                    flex: 3,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: light,
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        // mainAxisSize: MainAxisSize.max,
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
                                      initialDate: provider.startDate != null ? provider.startDate! : DateTime.now(),
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
                            Expanded(
                              flex: 10,
                              child: SingleChildScrollView(
                                child: SizedBox(
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
                              ),
                            ),
                          const SizedBox(height: 16),
                          const Spacer(flex: 1),
                          Row(
                            children: [
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
                                      child: Text(subModel['name'] ?? ""),
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
                                  if (provider.isAddingModelToOrder) {
                                    return;
                                  }
                                  provider.addModelToOrder(context);
                                },
                                icon: provider.isAddingModelToOrder
                                    ? SizedBox.square(
                                        dimension: 18,
                                        child: CircularProgressIndicator(strokeWidth: 2, color: light),
                                      )
                                    : const Icon(Icons.add_rounded),
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
                                    child: CircularProgressIndicator(strokeWidth: .5),
                                  )
                                else
                                  const Text("Buyurtmani qo'shish"),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // right side
                  Flexible(
                    flex: 2,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: light,
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Hom ashyolar",
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Expanded(
                            child: provider.isLoading
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : provider.recipeData.isEmpty
                                    ? const Center(
                                        child: Text.rich(
                                          TextSpan(
                                            text: "Hom ashyolar mavjud emas",
                                            children: [
                                              TextSpan(
                                                text: "\nBirorta ham model tanlanmagan!",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      )
                                    : ListView.builder(
                                        itemCount: provider.recipeData.length,
                                        itemBuilder: (context, index) {
                                          final data = provider.recipeData[index];

                                          return Container(
                                            width: double.infinity,
                                            margin: const EdgeInsets.only(bottom: 8),
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(8),
                                              color: secondary,
                                            ),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  "${data?['model']?['name']} - ${data?['submodel']} - ${data?['model_color']?['color']?['name']} - ${data?['size']?['name']}",
                                                  style: const TextStyle(fontSize: 16),
                                                ),
                                                const SizedBox(height: 8),
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: light,
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  child: Table(
                                                    border: TableBorder.all(
                                                      borderRadius: BorderRadius.circular(8),
                                                      color: dark.withAlpha(50),
                                                    ),
                                                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                                                    columnWidths: const {
                                                      0: FixedColumnWidth(48),
                                                      1: FlexColumnWidth(3),
                                                      2: FlexColumnWidth(2),
                                                      3: FlexColumnWidth(2),
                                                      4: FlexColumnWidth(2),
                                                    },
                                                    children: [
                                                      const TableRow(
                                                        children: [
                                                          TableCell(
                                                            child: Center(
                                                              child: Text(
                                                                "№",
                                                                style: TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight: FontWeight.bold,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          TableCell(
                                                            child: Padding(
                                                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                                              child: Center(
                                                                child: Text(
                                                                  "Material nomi",
                                                                  style: TextStyle(
                                                                    fontSize: 12,
                                                                    fontWeight: FontWeight.bold,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          TableCell(
                                                            child: Padding(
                                                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                              child: Center(
                                                                child: Text(
                                                                  "Kerak",
                                                                  style: TextStyle(
                                                                    fontSize: 12,
                                                                    fontWeight: FontWeight.bold,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          TableCell(
                                                            child: Padding(
                                                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                              child: Center(
                                                                child: Text(
                                                                  "Mavjud",
                                                                  style: TextStyle(
                                                                    fontSize: 12,
                                                                    fontWeight: FontWeight.bold,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      ...data['recipes'].map((recipe) {
                                                        int index = data['recipes'].indexOf(recipe) + 1;
                                                        Map stok = recipe['stok'] ?? {};
                                                        double stokQuantity = double.tryParse(stok['quantity'] ?? "0") ?? 0;

                                                        Map item = recipe['item'] ?? {};
                                                        double needQuantity = double.tryParse(recipe['quantity'] ?? "0") ?? 0;

                                                        return TableRow(
                                                          decoration: BoxDecoration(
                                                            color: stokQuantity >= needQuantity ? Colors.green[100] : Colors.red[100],
                                                          ),
                                                          children: [
                                                            TableCell(
                                                              child: Padding(
                                                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                                                child: Center(
                                                                  child: Text(
                                                                    "$index",
                                                                    style: const TextStyle(
                                                                      fontSize: 12,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            TableCell(
                                                              child: Padding(
                                                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                                                child: Text(
                                                                  "${item['name']}",
                                                                  style: const TextStyle(
                                                                    fontSize: 12,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            TableCell(
                                                              child: Padding(
                                                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                                                child: Center(
                                                                  child: Text.rich(
                                                                    TextSpan(
                                                                      children: [
                                                                        TextSpan(
                                                                          text: needQuantity.fromNum.toCurrency,
                                                                          style: TextStyle(
                                                                            fontSize: 12,
                                                                            fontWeight: FontWeight.w600,
                                                                          ),
                                                                        ),
                                                                        if (stok['item']?['unit'] != null)
                                                                          TextSpan(
                                                                            text: "\n${stok['item']?['unit']?['name']}",
                                                                            style: const TextStyle(
                                                                              fontSize: 12,
                                                                            ),
                                                                          ),
                                                                      ],
                                                                    ),
                                                                    textAlign: TextAlign.center,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            TableCell(
                                                              child: Padding(
                                                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                                                child: Center(
                                                                  child: Text.rich(
                                                                    TextSpan(
                                                                      children: [
                                                                        TextSpan(
                                                                          text: stokQuantity.fromNum.toCurrency,
                                                                          style: TextStyle(
                                                                            fontSize: 12,
                                                                            fontWeight: FontWeight.w600,
                                                                          ),
                                                                        ),
                                                                        if (stok['item']?['unit'] != null)
                                                                          TextSpan(
                                                                            text: "\n${stok['item']?['unit']?['name']}",
                                                                            style: const TextStyle(
                                                                              fontSize: 12,
                                                                            ),
                                                                          ),
                                                                      ],
                                                                    ),
                                                                    textAlign: TextAlign.center,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                      }),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                          ),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text.rich(
                                  TextSpan(
                                    text: "Jami model: ",
                                    children: [
                                      TextSpan(
                                        text: "${provider.orderModels.length}",
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const TextSpan(
                                        text: " ta",
                                        style: TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text.rich(
                                  TextSpan(
                                    text: "Jami summa: ",
                                    children: [
                                      TextSpan(
                                        text: provider.recipeData.fold<double>(0, (prev, model) => prev + (model['total_sum'] ?? 0)).toCurrency,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const TextSpan(
                                        text: "\$",
                                        style: TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                    spellOut: true,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Expanded(
                                      child: CustomInput(
                                        controller: provider.orderRasxodController,
                                        hint: "Rasxodingizni kiriting",
                                        color: secondary,
                                        formatters: [
                                          CurrencyInputFormatter(),
                                          FilteringTextInputFormatter.allow(RegExp(r'[0-9\,\.]')),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
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

/*
{
    "order_name": "",
    "quantity": 1,
    "start_date": "",
    "end_date": "",
    "models": [
        {
            "id": 1,
            "submodel": {},
            "model_color": {},
            "size": {},
            "quantity": 1,
            "rasxod": 1
        }
    ]
}
*/
