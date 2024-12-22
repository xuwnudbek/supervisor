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
                                          label: Row(
                                            children: [
                                              Text(
                                                "#",
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
                                      // horizontalMargin: 16,
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
                                                child: Text("${item['price']}\$"),
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
                                              SizedBox(
                                                width: 160,
                                                child: Center(
                                                  child: item['image'] == null || item['image'] == ""
                                                      ? const Text("Rasm yo'q")
                                                      : GestureDetector(
                                                          onTap: () {
                                                            Get.dialog(
                                                              Dialog(
                                                                backgroundColor: Colors.transparent,
                                                                child: Stack(
                                                                  children: [
                                                                    Container(
                                                                      margin: const EdgeInsets.all(36),
                                                                      child: item['image'].toString().contains("images")
                                                                          ? Image.network(
                                                                              "http://176.124.208.61:2005/storage/${item['image']}",
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
                                                                            )
                                                                          : 3 > 2
                                                                              ? const SizedBox.shrink()
                                                                              : Image.network(
                                                                                  "http://176.124.208.61:2025/media/${item['image']}",
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
                                                          child: true
                                                              ? const Text("Rasm yo'q")
                                                              : item['image'].toString().contains("images")
                                                                  ? Image.network(
                                                                      "http://176.124.208.61:2005/storage/${item['image']}",
                                                                      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                                                                        return ClipRRect(
                                                                          borderRadius: BorderRadius.circular(8),
                                                                          child: child,
                                                                        );
                                                                      },
                                                                      errorBuilder: (context, error, stackTrace) {
                                                                        return const Text("Rasmni yuklashda xatolik yuz berdi");
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
                                                                    )
                                                                  : 3 > 2
                                                                      ? const SizedBox.shrink()
                                                                      : Image.network(
                                                                          "http://176.124.208.61:2025/media/${item['image']}",
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
