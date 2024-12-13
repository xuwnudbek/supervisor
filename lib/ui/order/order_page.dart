import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:supervisor/ui/order/pages/add_order.dart';
import 'package:supervisor/ui/order/provider/order_provider.dart';
import 'package:supervisor/utils/RGB.dart';

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
                          await Get.to(() => AddOrder(orderProvider: provider));
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
                              : const SizedBox.shrink(
                                  child: Text("Nimadur bor!"),
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
