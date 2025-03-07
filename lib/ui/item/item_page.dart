import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:supervisor/ui/item/pages/add_item.dart';
import 'package:supervisor/ui/item/provider/item_provider.dart';
import 'package:supervisor/utils/extensions/list_extension.dart';
import 'package:supervisor/utils/themes/app_colors.dart';
import 'package:supervisor/utils/extensions/num_extension.dart';
import 'package:supervisor/utils/widgets/custom_image_widget.dart';
import 'package:supervisor/utils/widgets/custom_input.dart';
import 'package:supervisor/utils/widgets/custom_snackbars.dart';

class ItemPage extends StatefulWidget {
  const ItemPage({super.key});

  @override
  State<ItemPage> createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ChangeNotifierProvider<ItemProvider>(
      create: (context) => ItemProvider()..initialize(),
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
                    Text(
                      "Maxsulotlar",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: 250,
                      child: CustomInput(
                        hint: "Qidirish",
                        size: 40,
                        controller: provider.searchController,
                      ),
                    ),
                    const SizedBox(width: 8),
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
                        if (provider.isLoading) {
                          CustomSnackbars(context).warning("Iltimos, ma'lumotlar yuklanishini kutib turing!");
                          return;
                        }
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
                                  child: Table(
                                    border: TableBorder.all(
                                      color: dark.withAlpha(50),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    columnWidths: const {
                                      0: IntrinsicColumnWidth(),
                                      1: MaxColumnWidth(IntrinsicColumnWidth(), FixedColumnWidth(350)),
                                      2: IntrinsicColumnWidth(),
                                      3: IntrinsicColumnWidth(),
                                      4: IntrinsicColumnWidth(),
                                      5: MaxColumnWidth(FixedColumnWidth(100), FixedColumnWidth(100)),
                                      6: IntrinsicColumnWidth(),
                                      7: IntrinsicColumnWidth(),
                                    },
                                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
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
                                                padding: EdgeInsets.all(16.0),
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
                                            child: Padding(
                                              padding: EdgeInsets.all(16.0),
                                              child: Text(
                                                "Nomi",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                            child: Center(
                                              child: Padding(
                                                padding: EdgeInsets.all(16.0),
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
                                                padding: EdgeInsets.all(16.0),
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
                                                padding: EdgeInsets.all(16.0),
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
                                                padding: EdgeInsets.all(16.0),
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
                                                padding: EdgeInsets.all(16.0),
                                                child: Text(
                                                  "Maxsulot turi",
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
                                                padding: EdgeInsets.all(16.0),
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
                                      ...provider.items.qaysiki(['name'], provider.searchController.text).map((item) {
                                        int index = provider.items.indexOf(item);

                                        return TableRow(
                                          decoration: BoxDecoration(
                                            color: index.isEven ? Colors.white : Colors.white.withAlpha(50),
                                            border: Border(
                                              bottom: BorderSide(
                                                color: Colors.transparent,
                                              ),
                                            ),
                                          ),
                                          children: [
                                            TableCell(
                                              child: Center(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(16.0),
                                                  child: Text((++index).toString()),
                                                ),
                                              ),
                                            ),
                                            TableCell(
                                              child: Padding(
                                                padding: const EdgeInsets.all(16),
                                                child: SizedBox(
                                                  child: Text(item['name']),
                                                ),
                                              ),
                                            ),
                                            TableCell(
                                              child: Center(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(16.0),
                                                  child: Text("${num.parse(item['price']).toCurrency}\$"),
                                                ),
                                              ),
                                            ),
                                            TableCell(
                                              child: Center(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(16.0),
                                                  child: Text(
                                                    item?['unit']?['name'] ?? "O'lchov yo'q",
                                                  ),
                                                ),
                                              ),
                                            ),
                                            TableCell(
                                              child: Center(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(16.0),
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        "${item?['color']?['name']}",
                                                        textAlign: TextAlign.center,
                                                      ),
                                                      if (item?['color']?['hex'] != null)
                                                        SelectableText(
                                                          "#${item?['color']?['hex']}",
                                                          textAlign: TextAlign.center,
                                                          style: textTheme.bodySmall,
                                                        ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            TableCell(
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Center(
                                                  child: SizedBox(
                                                    height: 85,
                                                    child: CustomImageWidget(
                                                      image: item['image'] ?? "",
                                                      fit: BoxFit.cover,
                                                    ),
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
              ],
            ),
          );
        },
      ),
    );
  }
}
