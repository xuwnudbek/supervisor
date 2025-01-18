import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:supervisor/ui/order/pages/add_order.dart';
import 'package:supervisor/ui/order/pages/order_details.dart';
import 'package:supervisor/ui/order/provider/order_provider.dart';
import 'package:supervisor/utils/themes/app_colors.dart';
import 'package:supervisor/utils/widgets/custom_dotted_widget.dart';
import 'package:supervisor/utils/widgets/custom_snackbars.dart';
import 'package:supervisor/utils/widgets/hover_widget.dart';

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
      child: Consumer<OrderProvider>(
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
                        // if (provider.isLoading) {
                        //   CustomSnackbars(context).warning("Ma'lumotlar yuklanmoqda, iltimos kuting");
                        //   return;
                        // }
                        provider.initialize();
                      },
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      color: primary,
                      icon: const Icon(Icons.add),
                      onPressed: () async {
                        if (provider.isLoading) {
                          CustomSnackbars(context).warning(
                              "Ma'lumotlar yuklanmoqda, iltimos kuting");
                          return;
                        }
                        await Get.to(
                          () => ChangeNotifierProvider.value(
                            value: context.read<OrderProvider>(),
                            child: const AddOrder(),
                          ),
                        )?.then((value) {
                          if (value != null) {
                            provider.initialize();
                          }
                        });
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
                                    color: Colors.black.withValues(alpha: 0.5),
                                  ),
                                ),
                              )
                            : SingleChildScrollView(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: StaggeredGrid.count(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 12,
                                    mainAxisSpacing: 12,
                                    children: List.generate(
                                      provider.orders.length,
                                      (index) {
                                        var order = provider.orders[index];
                                        bool status =
                                            order['status'] == "active";

                                        return HoverWidget(
                                          onTap: () {
                                            Get.to(() => OrderDetails(
                                                orderId: order['id']));
                                          },
                                          builder: (isHovered) {
                                            return Container(
                                              padding: const EdgeInsets.all(16),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                boxShadow: [
                                                  if (isHovered)
                                                    BoxShadow(
                                                      color: dark.withValues(
                                                          alpha: 0.2),
                                                      blurRadius: 4,
                                                      offset:
                                                          const Offset(0, 4),
                                                    ),
                                                ],
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "Buyurtma №${order['id']}",
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "Nomi:  ",
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                      CustomDottedWidget(),
                                                      Text(
                                                        order['name'] ??
                                                            "Unknown",
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "B/S:  ",
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                      CustomDottedWidget(),
                                                      Text(
                                                        order['start_date']
                                                            .toString()
                                                            .split(" ")
                                                            .first,
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "T/S:  ",
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                      CustomDottedWidget(),
                                                      Text(
                                                        order['end_date']
                                                            .toString()
                                                            .split(" ")
                                                            .first,
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "Maxsulot:  ",
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                      CustomDottedWidget(),
                                                      Text(
                                                        "${order['quantity']} ta",
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "Holat:  ",
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                      CustomDottedWidget(),
                                                      ActionChip(
                                                        onPressed: () {
                                                          if (provider
                                                              .isUpdating) {
                                                            CustomSnackbars(
                                                                    context)
                                                                .warning(
                                                                    "Buyurtma yangilanmoqda, iltimos kuting");
                                                            return;
                                                          }
                                                          provider.updateOrder(
                                                            order['id'],
                                                            {
                                                              "status": status
                                                                  ? "inactive"
                                                                  : "active"
                                                            },
                                                            context: context,
                                                          );
                                                        },
                                                        backgroundColor: provider
                                                                .isUpdating
                                                            ? Colors.grey
                                                                .withValues(
                                                                    alpha: 0.2)
                                                            : status
                                                                ? Colors.green
                                                                    .withValues(
                                                                        alpha:
                                                                            0.2)
                                                                : Colors.red
                                                                    .withValues(
                                                                        alpha:
                                                                            0.2),
                                                        tooltip:
                                                            "Holatni o'zgartirish",
                                                        label: Text(
                                                          status
                                                              ? "Faol"
                                                              : "Faol emas",
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: provider
                                                                    .isUpdating
                                                                ? Colors.black
                                                                    .withValues(
                                                                        alpha:
                                                                            0.2)
                                                                : status
                                                                    ? Colors
                                                                        .green
                                                                    : Colors
                                                                        .red,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        );
                                      },
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
