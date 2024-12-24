
import 'package:flutter/material.dart';
import 'package:supervisor/services/http_service.dart';
import 'package:supervisor/utils/extensions/num_extension.dart';

class OrderDetailProvider extends ChangeNotifier {
  final int orderId;

  Map _orderData = {};
  Map _selectedOrderModel = {};
  double _totalPrice = 0;

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

  double get totalPrice => _totalPrice;
  set totalPrice(double value) {
    _totalPrice = value;
    notifyListeners();
  }

  Future<void> initialize() async {
    isLoading = true;

    await getOrder();
    collectModelsToTableRow();

    isLoading = false;
  }

  Future<void> getOrder() async {
    final response = await HttpService.get('$order/$orderId');
    if (response['status'] == Result.success) {
      orderData = response['data'];
    }
  }

  List<Map> collectModelsToTableRow() {
    totalPrice = 0;

    List<Map> orderModels = [];

    for (var orderModel in orderData['order_models'] ?? []) {
      List<TableRow> recipesTableRows = [];
      for (var submodels in orderModel?['submodels'] ?? []) {
        for (var recipe in submodels['recipes'] ?? []) {
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
                child: Text(
                  '${recipe['item']['name']}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            TableCell(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Text(
                  "${double.parse("${recipe['item']['price']}").toCurrency}\$",
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            TableCell(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Center(
                  child: Row(
                    children: [
                      Text(
                        "${num.parse(recipe['quantity']).toCurrency} ",
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        "/ ${recipe['item']['unit']['name']}",
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            TableCell(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Text(
                  "${(double.parse("${recipe['quantity']}") * double.parse("${recipe['item']['price']}")).toCurrency}\$",
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ]));
        }
      }

      totalPrice = totalPrice + double.parse("${orderModel['total_rasxod']}");

      orderModels.add({
        'order_model': orderModel,
        'recipes_table_rows': recipesTableRows,
      });
    }

    return orderModels;
  }
}
