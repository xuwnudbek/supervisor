import 'package:flutter/material.dart';
import 'package:supervisor/services/http_service.dart';
import 'package:supervisor/utils/extensions/num_extension.dart';

class OrderDetailProvider extends ChangeNotifier {
  final int orderId;
  double _totalPrice = 0;

  Map _orderData = {};
  Map _selectedOrderModel = {};
  List _groups = [];
  List _orderModels = [];

  bool _isLoading = false;

  List<ExpansionTileController> expansionTileControllers = [];

  Map get orderData => _orderData;
  set orderData(Map value) {
    _orderData = value;
    notifyListeners();
  }

  List get orderModels => _orderModels;
  set orderModels(List value) {
    _orderModels = value;
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

  List get groups => _groups;
  set groups(List value) {
    _groups = value;
    notifyListeners();
  }

  OrderDetailProvider(this.orderId) {
    initialize();
  }

  Future<void> initialize() async {
    isLoading = true;

    await getOrder();
    await getGroups();

    isLoading = false;
  }

  Future<void> getOrder() async {
    final response = await HttpService.get('$order/$orderId');
    if (response['status'] == Result.success) {
      orderData = response['data'];
      if (expansionTileControllers.isEmpty) {
        expansionTileControllers = List.generate(orderData['order_models'].length, (index) => ExpansionTileController());
        notifyListeners();
      }

      collectModelsToTableRow();
    }
  }

  Future<void> getGroups() async {
    final response = await HttpService.get(group);
    if (response['status'] == Result.success) {
      groups = response['data'];
      notifyListeners();
    }
  }

  Future<bool> fasteningOrderToGroup(int submodelId, int groupId) async {
    Map<String, dynamic> body = {
      "order_id": orderId,
      "submodel_id": submodelId,
      "group_id": groupId,
    };

    var res = await HttpService.post("/fasteningOrderToGroup", {
      "data": [body],
    });

    if (res['status'] == Result.success) {
      await getOrder();
      return true;
    } else {
      return false;
    }
  }

  void collectModelsToTableRow() {
    orderModels = [];

    double innerTotalPrice = 0;
    for (var orderModel in orderData['order_models'] ?? []) {
      List<TableRow> recipesTableRows = [];
      for (var submodels in orderModel?['submodels'] ?? []) {
        for (var recipe in submodels['recipes'] ?? []) {
          int index = recipesTableRows.length;
          recipesTableRows.add(
            TableRow(
              children: [
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "${double.parse("${recipe['item']['price']}").toCurrency}\$",
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
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
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "${(double.parse("${recipe['quantity']}") * double.parse("${recipe['item']['price']}")).toCurrency}\$",
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      }

      innerTotalPrice = innerTotalPrice + double.parse("${orderModel['total_rasxod']}");

      orderModels.add({
        'order_model': orderModel,
        'recipes_table_rows': recipesTableRows,
      });
    }

    totalPrice = innerTotalPrice;
  }
}
