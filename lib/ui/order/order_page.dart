import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:supervisor/services/storage_service.dart';
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
    final textTheme = Theme.of(context).textTheme;

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
                          CustomSnackbars(context).warning("Ma'lumotlar yuklanmoqda, iltimos kuting");
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
                            : Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GridView.count(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                  childAspectRatio: 1.8,
                                  children: List.generate(
                                    provider.orders.length,
                                    (index) {
                                      var order = provider.orders[index];
                                      bool isActive = order['status'] == "active";

                                      Color statusColor = order['status'] == "active"
                                          ? Colors.green
                                          : order['status'] == "inactive"
                                              ? Colors.red
                                              : Colors.orange;

                                      String status = order['status'] == "active"
                                          ? "Faol"
                                          : order['status'] == "inactive"
                                              ? "Faol emas"
                                              : order['status'] == "pending"
                                                  ? "Kutilmoqda"
                                                  : order['status'] == "cutting"
                                                      ? "Kesish"
                                                      : order['status'] == "printing"
                                                          ? "Chop etish"
                                                          : order['status'] == "tailoring"
                                                              ? "Tikuvda"
                                                              : order['status'] == "tailored"
                                                                  ? "Tikildi"
                                                                  : "Nomalum";

                                      return HoverWidget(
                                        onTap: () {
                                          Get.to(() => OrderDetails(orderId: order['id']));
                                        },
                                        builder: (isHovered) {
                                          return Container(
                                            padding: const EdgeInsets.all(16),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(8),
                                              boxShadow: [
                                                if (isHovered)
                                                  BoxShadow(
                                                    color: dark.withValues(alpha: 0.2),
                                                    blurRadius: 4,
                                                    offset: const Offset(0, 4),
                                                  ),
                                              ],
                                            ),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      "Buyurtma:  ",
                                                      style: textTheme.titleMedium,
                                                    ),
                                                    Text(
                                                      "#${order['id']}",
                                                      style: textTheme.titleMedium?.copyWith(
                                                        fontSize: 18,
                                                        color: primary,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                    Spacer(),
                                                    IconButton(
                                                      style: IconButton.styleFrom(
                                                        backgroundColor: Colors.transparent,
                                                        padding: EdgeInsets.zero,
                                                        fixedSize: Size.fromRadius(8),
                                                        minimumSize: Size.fromRadius(16),
                                                        iconSize: 16,
                                                      ),
                                                      onPressed: () async {
                                                        // if (provider.isUpdating) {
                                                        //   CustomSnackbars(context).warning("Buyurtma yangilanmoqda, iltimos kuting");
                                                        //   return;
                                                        // }

                                                        await Get.to(
                                                          () => ChangeNotifierProvider.value(
                                                            value: context.read<OrderProvider>(),
                                                            child: AddOrder(order: order),
                                                          ),
                                                        )?.then((value) {
                                                          if (value != null) {
                                                            provider.initialize();
                                                          }
                                                          StorageService.remove('order_id');
                                                        });
                                                      },
                                                      icon: Icon(
                                                        Icons.edit_rounded,
                                                        color: dark,
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
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                    CustomDottedWidget(),
                                                    Text(
                                                      order['name'] ?? "Unknown",
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w400,
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
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                    CustomDottedWidget(),
                                                    Text(
                                                      order['start_date'].toString().split(" ").first,
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w400,
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
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                    CustomDottedWidget(),
                                                    Text(
                                                      order['end_date'] == null ? "Noma'lum" : (order['end_date']).toString().split(" ").first,
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w400,
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
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                    CustomDottedWidget(),
                                                    Text(
                                                      "${order['quantity'] ?? 0} ta",
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w400,
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
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                    CustomDottedWidget(),
                                                    ActionChip(
                                                      onPressed: () {
                                                        if (order['status'] != "active" && order['status'] != "inactive") {
                                                          CustomSnackbars(context).warning("Bu buyurtma jarayonda, uni o'zgartirib o'lmaydi!");
                                                          return;
                                                        }

                                                        if (provider.isUpdating) {
                                                          CustomSnackbars(context).warning("Buyurtma yangilanmoqda, iltimos kuting");
                                                          return;
                                                        }
                                                        provider.updateOrder(
                                                          order['id'],
                                                          {"status": isActive ? "inactive" : "active"},
                                                          context: context,
                                                        );
                                                      },
                                                      backgroundColor: provider.isUpdating ? Colors.grey.withValues(alpha: 0.15) : statusColor.withValues(alpha: 0.15),
                                                      tooltip: "Holatni o'zgartirish",
                                                      label: Text(
                                                        status,
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.w400,
                                                          color: provider.isUpdating ? Colors.black.withValues(alpha: 0.15) : statusColor.withValues(alpha: 0.95),
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
              ],
            ),
          );
        },
      ),
    );
  }
}
