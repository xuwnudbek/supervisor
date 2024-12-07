import 'package:flutter/material.dart';
import 'package:supervisor/services/http_service.dart';

class OrderProvider extends ChangeNotifier {
  List _orders = [];
  List get orders => _orders;
  set orders(List orders) {
    _orders = orders;
    notifyListeners();
  }

  List _models = [];
  List get models => _models;
  set models(List models) {
    _models = models;
    notifyListeners();
  }

  bool isLoading = false;

  OrderProvider() {
    initialize();
  }

  Future<void> initialize() async {
    isLoading = true;
    notifyListeners();

    await getOrders();
    await getModels();

    isLoading = false;
    notifyListeners();
  }

  Future<void> getOrders() async {
    var res = await HttpService.get(order);
    if (res['status'] == Result.success) {
      orders = res['data'];
    }
  }

  Future<void> createOrder(Map<String, dynamic> body) async {
    var res = await HttpService.post(order, body);
    if (res['status'] == Result.success) {
      await getOrders();
    } else {
      print(res['data']);
    }
  }

  Future<void> updateOrder(int id, Map<String, dynamic> body) async {
    var res = await HttpService.patch("$order/$id", body);
    if (res['status'] == Result.success) {
      await getOrders();
    } else {
      print(res['data']);
    }
  }

  Future<void> getModels() async {
    var res = await HttpService.get(model);
    if (res['status'] == Result.success) {
      models = res['data'];
    }
  }
}
