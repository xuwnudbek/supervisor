import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:supervisor/ui/order/pages/add_order.dart';
import 'package:supervisor/ui/order/provider/order_provider.dart';
import 'package:supervisor/utils/RGB.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<OrderProvider>(
      create: (context) => OrderProvider(),
      builder: (context, snapshot) {
        return Consumer<OrderProvider>(
          builder: (context, provider, _) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Text(
                        "Buyurtmalar",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        color: primary,
                        icon: const Icon(Icons.refresh),
                        onPressed: () {
                          provider.initialize();
                        },
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        color: primary,
                        icon: const Icon(Icons.add),
                        onPressed: () async {
                          await Get.to(() => AddOrder(provider: provider));
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
                          : provider.orders.isEmpty
                              ? Center(
                                  child: Text(
                                    "Hozircha hech qanday buyurtma yo'q",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black.withOpacity(0.5),
                                    ),
                                  ),
                                )
                              : SingleChildScrollView(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: StaggeredGrid.count(
                                      crossAxisCount: 3,
                                      mainAxisSpacing: 16,
                                      crossAxisSpacing: 16,
                                      axisDirection: AxisDirection.down,
                                      children: provider.orders.map((order) {
                                        int index = provider.orders.indexOf(order);
                                        String status = order['status'];
                                        List orderModels = order['order_models'];

                                        return StaggeredGridTile.fit(
                                          crossAxisCellCount: 1,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(8),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey.shade200,
                                                  blurRadius: 10,
                                                  spreadRadius: 1,
                                                ),
                                              ],
                                            ),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text.rich(
                                                      TextSpan(
                                                        children: [
                                                          TextSpan(
                                                            text: "${index + 1}. ",
                                                            style: TextStyle(
                                                              fontSize: 18,
                                                              color: primary,
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                          TextSpan(
                                                            text: order['name'],
                                                            style: const TextStyle(
                                                              fontSize: 16,
                                                              color: Colors.black87,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.black87,
                                                      ),
                                                    ),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        color: (status == "active" ? Colors.green : Colors.red).withOpacity(0.2),
                                                        borderRadius: BorderRadius.circular(150),
                                                      ),
                                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                                      child: PopupMenuButton(
                                                        tooltip: "Buyurtma holati",
                                                        itemBuilder: (context) {
                                                          return status == "active"
                                                              ? const [
                                                                  PopupMenuItem(
                                                                    value: "inactive",
                                                                    child: Text(
                                                                      "Faol emas",
                                                                      style: TextStyle(
                                                                        color: Colors.red,
                                                                        fontWeight: FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ]
                                                              : [
                                                                  const PopupMenuItem(
                                                                    value: "active",
                                                                    child: Text(
                                                                      "Faol",
                                                                      style: TextStyle(
                                                                        color: Colors.green,
                                                                        fontWeight: FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ];
                                                        },
                                                        onSelected: (value) async {
                                                          await provider.updateOrder(order['id'], {
                                                            "status": value,
                                                          });
                                                        },
                                                        child: Text(
                                                          status == "active" ? "Faol" : "Faol emas",
                                                          style: TextStyle(
                                                            color: status == "active" ? Colors.green : Colors.red,
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 8),
                                                Table(
                                                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                                                  columnWidths: const {
                                                    0: FlexColumnWidth(1),
                                                    1: FlexColumnWidth(1),
                                                  },
                                                  border: TableBorder.all(
                                                    color: Colors.grey.shade200,
                                                  ),
                                                  children: [
                                                    TableRow(
                                                      decoration: BoxDecoration(
                                                        border: Border(
                                                          bottom: BorderSide(
                                                            color: Colors.grey.shade200,
                                                          ),
                                                        ),
                                                      ),
                                                      children: const [
                                                        Padding(
                                                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                          child: Text(
                                                            "Nomi",
                                                            style: TextStyle(
                                                              color: Colors.black87,
                                                              fontWeight: FontWeight.w600,
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                          child: Text(
                                                            "Miqdori",
                                                            style: TextStyle(
                                                              color: Colors.black87,
                                                              fontWeight: FontWeight.w600,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                Table(
                                                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                                                  columnWidths: const {
                                                    0: FlexColumnWidth(1),
                                                    1: FlexColumnWidth(1),
                                                  },
                                                  border: TableBorder.all(
                                                    color: Colors.grey.shade200,
                                                  ),
                                                  children: [
                                                    ...List.generate(orderModels.length, (index) {
                                                      Map orderModel = orderModels[index];
                                                      return TableRow(
                                                        decoration: BoxDecoration(
                                                          color: index.isOdd ? Colors.white : Colors.grey.shade200,
                                                        ),
                                                        children: [
                                                          Padding(
                                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                            child: Text(
                                                              orderModel['name'],
                                                              style: const TextStyle(
                                                                color: Colors.black87,
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                            child: Text(
                                                              orderModel['quantity'].toString(),
                                                              style: const TextStyle(
                                                                color: Colors.black87,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    }),
                                                  ],
                                                ),
                                                Table(
                                                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                                                  columnWidths: const {
                                                    0: FlexColumnWidth(1),
                                                    1: FlexColumnWidth(1),
                                                  },
                                                  border: TableBorder.all(
                                                    color: Colors.grey.shade200,
                                                  ),
                                                  children: [
                                                    TableRow(
                                                      children: [
                                                        const Padding(
                                                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                          child: Text(
                                                            "Jami",
                                                            style: TextStyle(
                                                              color: Colors.black87,
                                                              fontWeight: FontWeight.w600,
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                          child: Text(
                                                            "${order['quantity'] ?? "0"}",
                                                            style: const TextStyle(
                                                              color: Colors.black87,
                                                              fontWeight: FontWeight.w600,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }).toList(),
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
