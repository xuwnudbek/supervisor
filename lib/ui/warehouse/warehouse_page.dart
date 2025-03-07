import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:supervisor/ui/warehouse/pages/add_warehouse.dart';
import 'package:supervisor/ui/warehouse/provider/warehouse_provider.dart';
import 'package:supervisor/utils/extensions/datetime_extension.dart';
import 'package:supervisor/utils/extensions/num_extension.dart';
import 'package:supervisor/utils/themes/app_colors.dart';

class WarehousePage extends StatelessWidget {
  const WarehousePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => WarehouseProvider(),
      child: Consumer<WarehouseProvider>(
        builder: (context, provider, _) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    const Text(
                      "Omborlar",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      color: primary,
                      icon: const Icon(Icons.refresh),
                      onPressed: () async {
                        provider.initialize();
                      },
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      color: primary,
                      icon: const Icon(Icons.add),
                      onPressed: () async {
                        await Get.to(() => AddWarehouse(provider: provider))?.then((value) {
                          if (value == true) {
                            provider.initialize();
                          }
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: secondary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: provider.isLoading
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : provider.warehouses.isEmpty
                            ? Center(
                                child: Text("Omborlar topilmadi"),
                              )
                            : Padding(
                                padding: EdgeInsets.all(8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          ...provider.warehouses.map((warehouse) {
                                            bool isSelected = provider.selectedWarehouse == warehouse;

                                            return ChoiceChip(
                                              label: Text(
                                                warehouse['name'] ?? "Unknown",
                                              ),
                                              showCheckmark: false,
                                              labelPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                              selected: provider.selectedWarehouse == warehouse,
                                              onSelected: (value) {
                                                provider.selectedWarehouse = warehouse;
                                              },
                                              side: BorderSide(
                                                color: Colors.transparent,
                                              ),
                                              color: WidgetStatePropertyAll(isSelected ? primary : light),
                                            ).marginOnly(right: 8);
                                          }),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Expanded(
                                      child: Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: (provider.selectedWarehouse['stoks'] as List).isEmpty
                                            ? Center(
                                                child: Text("Omborda maxsulotlar topilmadi"),
                                              )
                                            : SingleChildScrollView(
                                                scrollDirection: Axis.horizontal,
                                                child: SingleChildScrollView(
                                                  scrollDirection: Axis.vertical,
                                                  child: DataTable(
                                                    border: TableBorder.all(
                                                      color: dark.withAlpha(50),
                                                      borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                                                    ),
                                                    headingRowHeight: 46,
                                                    columns: [
                                                      DataColumn(
                                                        label: Center(
                                                          child: Text(
                                                            "№",
                                                            style: TextStyle(fontWeight: FontWeight.w600),
                                                          ),
                                                        ),
                                                      ),
                                                      DataColumn(
                                                        label: Text(
                                                          "Maxsulot",
                                                          style: TextStyle(fontWeight: FontWeight.w600),
                                                        ),
                                                      ),
                                                      DataColumn(
                                                        headingRowAlignment: MainAxisAlignment.center,
                                                        label: Text(
                                                          "Kod",
                                                          style: TextStyle(fontWeight: FontWeight.w600),
                                                          textAlign: TextAlign.center,
                                                        ),
                                                      ),
                                                      DataColumn(
                                                        tooltip: "Miqdor bo'yicha tartiblash",
                                                        onSort: (index, _) {
                                                          provider.sortBy(index, 'quantity', true);
                                                        },
                                                        mouseCursor: WidgetStatePropertyAll(SystemMouseCursors.click),
                                                        headingRowAlignment: MainAxisAlignment.center,
                                                        label: Row(
                                                          children: [
                                                            if (provider.sortIndex == 3)
                                                              Icon(
                                                                provider.sortingDirections[3] ?? false ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
                                                                size: 16,
                                                              ),
                                                            SizedBox(width: 4),
                                                            Text(
                                                              "Miqdor",
                                                              style: TextStyle(fontWeight: FontWeight.w600),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      DataColumn(
                                                        headingRowAlignment: MainAxisAlignment.center,
                                                        label: Text(
                                                          "O'lchov",
                                                          style: TextStyle(fontWeight: FontWeight.w600),
                                                        ),
                                                      ),
                                                      DataColumn(
                                                        headingRowAlignment: MainAxisAlignment.center,
                                                        label: Text(
                                                          "Turi",
                                                          style: TextStyle(fontWeight: FontWeight.w600),
                                                        ),
                                                      ),
                                                      DataColumn(
                                                        numeric: true,
                                                        tooltip: "Ohirgi yangilanish bo'yicha tartiblash",
                                                        onSort: (index, _) {
                                                          provider.sortBy(index, 'last_updated', false);
                                                        },
                                                        label: Center(
                                                          child: Row(
                                                            children: [
                                                              if (provider.sortIndex == 5)
                                                                Icon(
                                                                  provider.sortingDirections[5] ?? false ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
                                                                  size: 16,
                                                                ),
                                                              SizedBox(width: 4),
                                                              Text(
                                                                "Ohirgi yangilanish",
                                                                style: TextStyle(fontWeight: FontWeight.w600),
                                                                textAlign: TextAlign.center,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                    rows: (provider.selectedWarehouse['stoks'] as List).map<DataRow>((stok) {
                                                      int index = provider.selectedWarehouse['stoks'].indexOf(stok);

                                                      Map item = stok['item'];

                                                      num quantity = num.tryParse(stok['quantity']) ?? 0;
                                                      double minQuantity = double.tryParse(stok['min_quantity']) ?? 0;
                                                      DateTime lastUpdated = DateTime.parse(stok['last_updated']);

                                                      Color color = quantity.itemStatus(minQuantity);

                                                      return DataRow(
                                                        color: WidgetStateProperty.all(color),
                                                        cells: [
                                                          DataCell(
                                                            Center(
                                                              child: Text("${index + 1}"),
                                                            ),
                                                          ),
                                                          DataCell(
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              children: [
                                                                Text.rich(
                                                                  TextSpan(
                                                                    children: [
                                                                      if (color != Colors.transparent)
                                                                        WidgetSpan(
                                                                          child: Tooltip(
                                                                            message: quantity > 0 ? "Maxsulot minimal miqdordan kam!\nQolgan:  $quantity ${item['unit']?['name'] ?? "Unknown"}\nMinimal:  $minQuantity ${item['unit']?['name'] ?? "Unknown"}" : "Maxsulot omborda tugagan!",
                                                                            textStyle: TextStyle(
                                                                              fontSize: quantity > 0 ? 12 : 16,
                                                                              color: Colors.white,
                                                                            ),
                                                                            decoration: BoxDecoration(
                                                                              color: Colors.deepOrange,
                                                                              borderRadius: BorderRadius.circular(4),
                                                                              boxShadow: [
                                                                                BoxShadow(
                                                                                  color: Colors.black.withValues(alpha: 0.1),
                                                                                  blurRadius: 4,
                                                                                  offset: Offset(0, 2),
                                                                                )
                                                                              ],
                                                                            ),
                                                                            child: Icon(
                                                                              Icons.warning_rounded,
                                                                              color: warning,
                                                                            ).marginOnly(right: 8),
                                                                          ),
                                                                        ),
                                                                      TextSpan(
                                                                        text: "${item['name'] ?? "Unknown"}",
                                                                        style: const TextStyle(
                                                                          fontWeight: FontWeight.w500,
                                                                        ),
                                                                      ),
                                                                      TextSpan(
                                                                        text: " (${item['color']?['name'] ?? "Rang mavjud emas"})",
                                                                        style: TextStyle(
                                                                          color: dark.withAlpha(150),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          DataCell(
                                                            Center(
                                                              child: Text(
                                                                item['code'] ?? "-",
                                                              ),
                                                            ),
                                                          ),
                                                          DataCell(
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.end,
                                                              children: [
                                                                Text(
                                                                  quantity.toCurrency,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          DataCell(
                                                            Text((item['unit']?['name'] ?? "Unknown").toString().toLowerCase()),
                                                          ),
                                                          DataCell(
                                                            Center(child: Text(item['type']?['name'] ?? "unknown")),
                                                          ),
                                                          DataCell(
                                                            Center(
                                                              child: Text(
                                                                lastUpdated.format ?? "Unknown",
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
                                    )
                                  ],
                                ),
                              ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/*
{
  "id": 41,
  "quantity": "0.00",
  "last_updated": "2024-12-15 08:40:10.031518+05",
  "min_quantity": "0.00",
  "item": {
      "id": 42,
      "name": "Тикув машинаси jack F5",
      "price": "777",
      "image": "rasmlar/tkan_iR4lYgN.jpg",
      "code": "jackF5",
      "qr_code": "331dd5a9-8348-4756-9dfc-e79b63669923",
      "unit": {
          "id": 3,
          "name": "Dona"
      },
      "color": {
          "id": 9,
          "name": "Red Black",
          "hex": "F4F9FF"
      },
      "type": {
          "id": 3,
          "name": "Oshxona"
      }
  }
},
*/
