import 'package:flutter/material.dart';
import 'package:supervisor/services/http_service.dart';
import 'package:supervisor/utils/widgets/custom_snackbars.dart';

class OrderProvider extends ChangeNotifier {
  List _orders = [];
  List _models = [];
  List _items = [];
  List _materials = [];
  List _contragents = [];
  bool _isLoading = false;
  bool _isUpdating = false;

  List get orders => _orders;
  set orders(List value) {
    _orders = value;
    notifyListeners();
  }

  List get items => _items;
  set items(List value) {
    _items = value;
    notifyListeners();
  }

  List get materials => _materials;
  set materials(List value) {
    _materials = value;
    notifyListeners();
  }

  List get models => _models;
  set models(List value) {
    _models = value;
    notifyListeners();
  }

  List get contragents => _contragents;
  set contragents(List value) {
    _contragents = value;
    notifyListeners();
  }

  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  bool get isUpdating => _isUpdating;
  set isUpdating(bool value) {
    _isUpdating = value;
    notifyListeners();
  }

  OrderProvider() {
    initialize();
  }

  Future<void> initialize() async {
    isLoading = true;

    await getOrders();
    await getModels();
    await getItems();
    await getMaterials();
    getContragents();

    isLoading = false;
  }

  Future<void> getOrders() async {
    var res = await HttpService.get(order);
    if (res['status'] == Result.success) {
      orders = res['data'];
    }
  }

  Future<void> getItems() async {
    var res = await HttpService.get(item);
    if (res['status'] == Result.success) {
      items = res['data'];
    }
  }

  Future<void> getMaterials() async {
    var res = await HttpService.get(material);
    if (res['status'] == Result.success) {
      materials = res['data'];
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
    } else {}
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
