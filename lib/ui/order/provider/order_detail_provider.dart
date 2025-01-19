import 'package:flutter/material.dart';
import 'package:supervisor/services/http_service.dart';

class OrderDetailProvider extends ChangeNotifier {
  final int orderId;

  Map _orderData = {};
  Map _orderModel = {};

  bool _isLoading = false;

  List<ExpansionTileController> expansionTileControllers = [];

  Map get orderData => _orderData;
  set orderData(Map value) {
    _orderData = value;
    notifyListeners();
  }

  Map get orderModel => _orderModel;
  set orderModel(Map value) {
    _orderModel = value;
    notifyListeners();
  }

  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  num get getRecipesTotalPrice {
    num summa = 0;

    for (var submodel in orderModel['submodels'] ?? []) {
      for (var recipe in submodel['recipes'] ?? []) {
        summa += (num.tryParse(recipe['quantity'] ?? "") ?? 0) * (num.tryParse(recipe['item']?['price'] ?? "") ?? 0);
      }
    }

    return summa;
  }

  OrderDetailProvider(this.orderId);

  Future<void> initialize() async {
    isLoading = true;

    await getOrder();

    isLoading = false;
  }

  Future<void> getOrder() async {
    final response = await HttpService.get('$order/$orderId');
    if (response['status'] == Result.success) {
      orderData = response['data'];
      orderModel = orderData['order_model'];
    }
  }
}
