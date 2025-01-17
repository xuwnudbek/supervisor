import 'package:flutter/material.dart';
import 'package:supervisor/services/http_service.dart';
import 'package:supervisor/utils/widgets/custom_snackbars.dart';

class OrderProvider extends ChangeNotifier {
  List _orders = [];
  List _models = [];
  List _contragents = [];
  bool _isLoading = false;
  bool _isUpdating = false;

  List get orders => _orders;
  set orders(List orders) {
    _orders = orders;
    notifyListeners();
  }

  List get models => _models;
  set models(List models) {
    _models = models;
    notifyListeners();
  }

  List get contragents => _contragents;
  set contragents(List contragents) {
    _contragents = contragents;
    notifyListeners();
  }

  bool get isLoading => _isLoading;
  set isLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  bool get isUpdating => _isUpdating;
  set isUpdating(bool isUpdating) {
    _isUpdating = isUpdating;
    notifyListeners();
  }

  OrderProvider() {
    initialize();
  }

  Future<void> initialize() async {
    isLoading = true;

    await getOrders();
    await getModels();
    getContragents();

    isLoading = false;
  }

  Future<void> getOrders() async {
    var res = await HttpService.get(order);
    if (res['status'] == Result.success) {
      orders = res['data'];
    }
  }

  Future<void> getContragents() async {
    var res = await HttpService.get(contragent);
    if (res['status'] == Result.success) {
      contragents = res['data'];
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

  Future<void> updateOrder(int id, Map<String, dynamic> body, {BuildContext? context}) async {
    isUpdating = true;

    var res = await HttpService.patch("$order/$id", body);
    if (res['status'] == Result.success) {
      await getOrders();
      if (context != null) {
        CustomSnackbars(context).success("Buyurtma muvaffaqiyatli o'zgartirildi");
      }
    } else {
      if (context != null) {
        CustomSnackbars(context).success("Buyurtma o'zgartirishda xatolik yuz berdi");
      }
    }

    isUpdating = false;
  }

  Future<void> getModels() async {
    var res = await HttpService.get(model);
    if (res['status'] == Result.success) {
      models = res['data'];
    }
  }
}
