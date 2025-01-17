import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:supervisor/ui/item/pages/add_item.dart';
import 'package:supervisor/ui/item/provider/item_provider.dart';
import 'package:supervisor/utils/themes/app_colors.dart';
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
                                    color: Colors.black.withValues(alpha: 0.5),
                                  ),
                                ),
                              )
                            : Padding(
                                padding: EdgeInsets.all(8),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: Table(
                                      border: TableBorder.all(
                                        color: dark.withAlpha(50),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      defaultColumnWidth: const IntrinsicColumnWidth(),
                                      columnWidths: const {
                                        0: FlexColumnWidth(0.5),
                                        1: FlexColumnWidth(1),
                                        2: FlexColumnWidth(0.5),
                                        3: FlexColumnWidth(0.5),
                                        4: FlexColumnWidth(0.5),
                                        5: FlexColumnWidth(1),
                                        6: FlexColumnWidth(1),
                                        7: FlexColumnWidth(0.5),
                                      },
                                      children: [
                                        // Table Header
                                        TableRow(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          children: const [
                                            TableCell(
                                              child: Center(
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(vertical: 16.0),
                                                  child: Text(
                                                    "#",
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            TableCell(
                                              child: Center(
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(vertical: 16.0),
                                                  child: Text(
                                                    "Nomi",
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            TableCell(
                                              child: Center(
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(vertical: 16.0),
                                                  child: Text(
                                                    "Narxi",
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            TableCell(
                                              child: Center(
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(vertical: 16.0),
                                                  child: Text(
                                                    "O'lchov",
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            TableCell(
                                              child: Center(
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(vertical: 16.0),
                                                  child: Text(
                                                    "Rang",
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            TableCell(
                                              child: Center(
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(vertical: 16.0),
                                                  child: Text(
                                                    "Rasm",
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            TableCell(
                                              child: Center(
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(vertical: 16.0),
                                                  child: Text(
                                                    "Material turi",
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            TableCell(
                                              child: Center(
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(vertical: 16.0),
                                                  child: Text(
                                                    "Amallar",
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        // Table Rows
                                        ...provider.items.map((item) {
                                          int index = provider.items.indexOf(item);

                                          return TableRow(
                                            children: [
                                              TableCell(
                                                child: Center(
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                                                    child: Text((++index).toString()),
                                                  ),
                                                ),
                                              ),
                                              TableCell(
                                                child: Center(
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                                                    child: SizedBox(
                                                      child: Text(item['name']),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              TableCell(
                                                child: Center(
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                                                    child: Text("${num.parse(item['price']).toCurrency}\$"),
                                                  ),
                                                ),
                                              ),
                                              TableCell(
                                                child: Center(
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                                                    child: Text(
                                                      item?['unit']?['name'] ?? "O'lchov yo'q",
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              TableCell(
                                                child: Center(
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                                                    child: Text(item?['color']?['name'] ?? "Rang yo'q"),
                                                  ),
                                                ),
                                              ),
                                              TableCell(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(4.0),
                                                  child: Center(
                                                    child: SizedBox(
                                                      width: 200,
                                                      height: 200,
                                                      child: CustomImageWidget(image: item['image'] ?? ""),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              TableCell(
                                                child: Center(
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                                                    child: Text(item?['type']?['name'] ?? "Mavjud emas"),
                                                  ),
                                                ),
                                              ),
                                              TableCell(
                                                child: Center(
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                                                    child: IconButton(
                                                      icon: const Icon(Icons.edit),
                                                      onPressed: () async {
                                                        await Get.to(() => AddItem(provider: provider, item: item));
                                                      },
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
