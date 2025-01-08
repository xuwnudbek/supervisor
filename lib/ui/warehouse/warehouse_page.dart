import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:supervisor/ui/warehouse/provider/warehouse_provider.dart';
import 'package:supervisor/utils/extensions/datetime_extension.dart';
import 'package:supervisor/utils/extensions/num_extension.dart';
import 'package:supervisor/utils/rgb.dart';

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
            child: provider.isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : provider.warehouses.isEmpty
                    ? Center(
                        child: Text("Omborlar topilmadi"),
                      )
                    : Column(
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
                                onPressed: () async {},
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                color: primary,
                                icon: const Icon(Icons.add),
                                onPressed: () async {},
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: secondary,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: EdgeInsets.all(8),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      ...provider.warehouses.map((warehouse) {
                                        return TextButton(
                                          onPressed: () {
                                            provider.selectedWarehouse = warehouse;
                                          },
                                          child: Text("${warehouse['name']}"),
                                        ).marginOnly(right: 8);
                                      }),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Column(
                                        children: [
                                          Table(
                                            border: TableBorder.all(
                                              color: dark.withAlpha(50),
                                              borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                                            ),
                                            columnWidths: {
                                              0: FixedColumnWidth(60),
                                              1: FlexColumnWidth(1),
                                              2: FixedColumnWidth(150),
                                              3: FixedColumnWidth(150),
                                              4: FixedColumnWidth(100),
                                            },
                                            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                                            children: [
                                              TableRow(children: [
                                                TableCell(
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Center(
                                                      child: Text(
                                                        "@",
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                TableCell(
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Text(
                                                      "Maxsulot",
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                TableCell(
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Center(
                                                      child: Text(
                                                        "Last updated",
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                TableCell(
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Center(
                                                      child: Text(
                                                        "Miqdor",
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                TableCell(
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Center(
                                                      child: Text(
                                                        "Unit",
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ]),
                                            ],
                                          ),
                                          Expanded(
                                            child: SingleChildScrollView(
                                              child: Table(
                                                border: TableBorder.all(
                                                  color: dark.withAlpha(50),
                                                ),
                                                columnWidths: {
                                                  0: FixedColumnWidth(60),
                                                  // 1: FlexColumnWidth(1),
                                                  2: FixedColumnWidth(150),
                                                  3: FixedColumnWidth(150),
                                                  4: FixedColumnWidth(100),
                                                },
                                                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                                                children: [
                                                  ...provider.selectedWarehouse['stoks'].map((stok) {
                                                    int index = provider.selectedWarehouse['stoks'].indexOf(stok);
                                                    Map item = stok['item'];
                                                    double quantity = double.tryParse(stok['quantity']) ?? 0;
                                                    double minQuantity = double.tryParse(stok['min_quantity']) ?? 0;
                                                    DateTime lastUpdated = DateTime.parse(stok['last_updated']);

                                                    return TableRow(children: [
                                                      TableCell(
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: Center(child: Text("${index + 1}")),
                                                        ),
                                                      ),
                                                      TableCell(
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: Text.rich(
                                                            TextSpan(
                                                              children: [
                                                                TextSpan(
                                                                  text: "${item['name']}",
                                                                  style: TextStyle(
                                                                    fontWeight: FontWeight.w600,
                                                                  ),
                                                                ),
                                                                TextSpan(
                                                                  text: " (${item['color']['name']} - ",
                                                                  style: TextStyle(
                                                                    color: dark.withAlpha(150),
                                                                  ),
                                                                ),
                                                                TextSpan(
                                                                  text: "${item['code']})",
                                                                  style: TextStyle(
                                                                    color: dark.withAlpha(150),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      TableCell(
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: Center(child: Text(lastUpdated.format)),
                                                        ),
                                                      ),
                                                      TableCell(
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.end,
                                                            children: [
                                                              Text("$quantity"),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      TableCell(
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: Center(
                                                            child: Text(item['unit']['name'].toString().toLowerCase()),
                                                          ),
                                                        ),
                                                      ),
                                                    ]);
                                                  }),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
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