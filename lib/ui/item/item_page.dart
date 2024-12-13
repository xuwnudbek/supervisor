import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:supervisor/ui/item/pages/add_item.dart';
import 'package:supervisor/ui/item/provider/item_provider.dart';
import 'package:supervisor/utils/RGB.dart';

class ItemPage extends StatefulWidget {
  const ItemPage({super.key});

  @override
  State<ItemPage> createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ItemProvider>(
      create: (context) => ItemProvider(),
      builder: (context, snapshot) {
        return Consumer<ItemProvider>(
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
                        "Materiallar",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        color: primary,
                        icon: const Icon(Icons.refresh),
                        onPressed: () async {
                          await provider.getItems();
                        },
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        color: primary,
                        icon: const Icon(Icons.add),
                        onPressed: () async {
                          await Get.to(() => AddItem(provider: provider));
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
                          : provider.items.isEmpty
                              ? Center(
                                  child: Text(
                                    "Hozircha hech qanday material yo'q",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black.withOpacity(0.5),
                                    ),
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        DataTable(
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
                                                ),
                                              ),
                                              headingRowAlignment: MainAxisAlignment.center,
                                            ),
                                            DataColumn(
                                              label: Text(
                                                "Nomi",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              headingRowAlignment: MainAxisAlignment.center,
                                            ),
                                            DataColumn(
                                              label: Text(
                                                "Price",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              headingRowAlignment: MainAxisAlignment.center,
                                            ),
                                            DataColumn(
                                              label: Text(
                                                "Unit",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              headingRowAlignment: MainAxisAlignment.center,
                                            ),
                                            DataColumn(
                                              label: Text(
                                                "Color",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              headingRowAlignment: MainAxisAlignment.center,
                                            ),
                                            DataColumn(
                                              label: Text(
                                                "Image",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              headingRowAlignment: MainAxisAlignment.center,
                                            ),
                                            DataColumn(
                                              label: Text(
                                                "Item Type",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              headingRowAlignment: MainAxisAlignment.center,
                                            ),
                                            DataColumn(
                                              label: Text(
                                                "Actions",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              headingRowAlignment: MainAxisAlignment.center,
                                            ),
                                          ],
                                          rows: provider.items
                                              .map(
                                                (item) => DataRow(
                                                  cells: [
                                                    DataCell(
                                                      Center(
                                                        child: Text(item['id'].toString()),
                                                      ),
                                                    ),
                                                    DataCell(
                                                      Center(
                                                        child: Text(item['name']),
                                                      ),
                                                    ),
                                                    DataCell(
                                                      Center(
                                                        child: Text(item['price'].toString()),
                                                      ),
                                                    ),
                                                    DataCell(
                                                      Center(
                                                        child: Text(item['unit']['name']),
                                                      ),
                                                    ),
                                                    DataCell(
                                                      Center(
                                                        child: Text(item['color']['name']),
                                                      ),
                                                    ),
                                                    DataCell(
                                                      Center(
                                                        child: item['image'] == null || item['image'] == ""
                                                            ? const Text("No image")
                                                            : GestureDetector(
                                                                onTap: () {
                                                                  Get.dialog(
                                                                    Dialog(
                                                                      backgroundColor: Colors.transparent,
                                                                      child: Stack(
                                                                        children: [
                                                                          Container(
                                                                            margin: const EdgeInsets.all(36),
                                                                            child: Image.network(
                                                                              "http://192.168.0.${item['image'].toString().contains("images") ? '123:8000/storage/${item['image']}' : '106:2004/media/${item['image']}'}",
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
                                                                          Positioned(
                                                                            right: 0,
                                                                            child: IconButton(
                                                                              style: IconButton.styleFrom(
                                                                                backgroundColor: Colors.white,
                                                                              ),
                                                                              icon: const Icon(Icons.close),
                                                                              onPressed: () {
                                                                                Get.back();
                                                                              },
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  );
                                                                },
                                                                child: Image.network(
                                                                  "http://192.168.0.${item['image'].toString().contains("images") ? '123:8000/storage/${item['image']}' : '106:2004/media/${item['image']}'}",
                                                                  width: 100,
                                                                  height: 100,
                                                                  // loading
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
                                                        child: Text(item['type']['name']),
                                                      ),
                                                    ),
                                                    DataCell(
                                                      Center(
                                                        child: Row(
                                                          children: [
                                                            IconButton(
                                                              icon: const Icon(Icons.edit),
                                                              onPressed: () async {
                                                                await Get.to(() => AddItem(provider: provider, item: item));
                                                              },
                                                            ),
                                                            const SizedBox(width: 8),
                                                            IconButton(
                                                              style: IconButton.styleFrom(
                                                                backgroundColor: danger.withOpacity(0.1),
                                                              ),
                                                              icon: const Icon(Icons.delete),
                                                              color: danger,
                                                              onPressed: () async {
                                                                await provider.deleteItem(item['id']);
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                              .toList(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
