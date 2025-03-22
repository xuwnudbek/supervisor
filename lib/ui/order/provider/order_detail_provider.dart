import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supervisor/services/http_service.dart';
import 'package:supervisor/utils/widgets/custom_snackbars.dart';

class OrderDetailProvider extends ChangeNotifier {
  final int orderId;

  Map _orderData = {};
  Map get orderData => _orderData;
  set orderData(Map value) {
    _orderData = value;
    notifyListeners();
  }

  Map _orderModel = {};
  Map get orderModel => _orderModel;
  set orderModel(Map value) {
    _orderModel = value;
    notifyListeners();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  num get getRecipesTotalPrice {
    num summa = 0;

    for (var submodel in orderModel['submodels'] ?? []) {
      for (var recipe in submodel['submodel']?['order_recipes'] ?? []) {
        summa += (num.tryParse(recipe['quantity'] ?? "") ?? 0) * (num.tryParse(recipe['item']?['price'] ?? "") ?? 0);
      }
    }

    return summa;
  }

  OrderDetailProvider(this.orderId);

  bool _isOrderCopying = false;
  bool get isOrderCopying => _isOrderCopying;
  set isOrderCopying(bool value) {
    _isOrderCopying = value;
    notifyListeners();
  }

  Future<void> copyOrder(BuildContext context) async {
    isOrderCopying = true;

    var res = await HttpService.get("$order/$orderId");

    if (res['status'] == Result.success) {
      Clipboard.setData(ClipboardData(text: jsonEncode(res['data'])));
      CustomSnackbars(context).success("Buyurtma nusxasi olindi ✅");
    }

    isOrderCopying = false;
  }

  Future<void> initialize() async {
    isLoading = true;

    await getOrder();

    isLoading = false;
  }

  Future<void> getOrder() async {
    final response = await HttpService.get('$order/$orderId');
    if (response['status'] == Result.success) {
      orderData = response['data'] ?? {};
      orderModel = orderData['order_model'] ?? {};
    }
  }
}
