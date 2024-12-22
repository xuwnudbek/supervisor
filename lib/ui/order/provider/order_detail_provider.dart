import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:supervisor/services/http_service.dart';

class OrderDetailProvider extends ChangeNotifier {
  final int orderId;

  Map _orderData = {};
  Map _selectedOrderModel = {};

  bool _isLoading = false;

  OrderDetailProvider(this.orderId) {
    initialize();
  }

  Map get orderData => _orderData;
  set orderData(Map value) {
    _orderData = value;
    notifyListeners();
  }

  Map get selectedOrderModel => _selectedOrderModel;
  set selectedOrderModel(Map value) {
    _selectedOrderModel = value;
    notifyListeners();
  }

  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> initialize() async {
    isLoading = true;

    await getOrder();

    isLoading = false;
  }

  Future<void> getOrder() async {
    log("$order/$orderId");
    final response = await HttpService.get('$order/$orderId');
    if (response['status'] == Result.success) {
      orderData = response['data'];
    }
  }

  List<TableRow> collectRecipesToTableRow() {
    List<TableRow> recipesTableRows = [];

    for (var orderModel in orderData['order_models'] ?? []) {
      for (var submodels in orderModel?['submodels'] ?? []) {
        for (var recipe in submodels['recipes']) {
          int index = recipesTableRows.length;
          recipesTableRows.add(TableRow(children: [
            TableCell(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
            TableCell(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Center(
                  child: Text(
                    '${recipe['item']['name']}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
            TableCell(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Center(
                  child: Text(
                    '${recipe['item']['price']}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
            TableCell(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Center(
                  child: Text(
                    '${recipe['quantity']}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
            TableCell(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Center(
                  child: Text(
                    '${recipe['quantity']} ${recipe['item']['price']}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ]));
        }
      }
    }

    return recipesTableRows;
  }
}
