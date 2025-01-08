import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:supervisor/ui/item/pages/add_item.dart';
import 'package:supervisor/ui/item/provider/item_provider.dart';
import 'package:supervisor/utils/RGB.dart';
import 'package:supervisor/utils/extensions/num_extension.dart';
import 'package:supervisor/utils/widgets/custom_image_widget.dart';

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
      child: Consumer<ItemProvider>(
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
                                  scrollDirection: Axis.horizontal,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: DataTable(
                                      border: TableBorder.all(
                                        color: dark.withAlpha(50),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      headingRowHeight: 52,
                                      dataRowMaxHeight: 52,
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
                                          headingRowAlignment: MainAxisAlignment.center,
                                        ),
                                        DataColumn(
                                          label: Row(
                                            children: [
                                              Text(
                                                "Nomi",
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
                                                "Narxi",
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
                                                "O'lchov",
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
                                                "Rang",
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
                                                "Rasm",
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
                                                "Material turi",
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
                                                "Amallar",
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
                                      rows: provider.items.map((item) {
                                        int index = provider.items.indexOf(item);

                                        return DataRow(
                                          cells: [
                                            DataCell(
                                              Center(
                                                child: Text((++index).toString()),
                                              ),
                                            ),
                                            DataCell(
                                              Center(
                                                child: SizedBox(
                                                  width: 300,
                                                  child: Text(item['name']),
                                                ),
                                              ),
                                            ),
                                            DataCell(
                                              Center(
                                                child: Text("${num.parse(item['price']).toCurrency}\$"),
                                              ),
                                            ),
                                            DataCell(
                                              Center(
                                                child: Text(
                                                  item?['unit']?['name'] ?? "O'lchov yo'q",
                                                ),
                                              ),
                                            ),
                                            DataCell(
                                              Center(
                                                child: Text(item?['color']?['name'] ?? "Rang yo'q"),
                                              ),
                                            ),
                                            DataCell(
                                              Container(
                                                width: 200,
                                                height: 200,
                                                padding: const EdgeInsets.all(4),
                                                child: Center(
                                                  child: CustomImageWidget(image: item['image'] ?? ""),
                                                ),
                                              ),
                                            ),
                                            DataCell(
                                              Center(
                                                child: Text(item?['type']?['name'] ?? "Mavjud emas"),
                                              ),
                                            ),
                                            DataCell(
                                              Center(
                                                child: IconButton(
                                                  icon: const Icon(Icons.edit),
                                                  onPressed: () async {
                                                    await Get.to(() => AddItem(provider: provider, item: item));
                                                  },
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
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
