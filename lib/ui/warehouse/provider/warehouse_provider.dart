import 'package:flutter/material.dart';
import 'package:supervisor/services/http_service.dart';

class WarehouseProvider extends ChangeNotifier {
  // private properties
  List _warehouses = [];
  Map _selectedWarehouse = {};
  bool _isLoading = false;

  // getters & setters
  List get warehouses => _warehouses;
  set warehouses(List value) {
    _warehouses = value;
    notifyListeners();

    if (warehouses.isNotEmpty) {
      selectedWarehouse = warehouses.first;
    }
  }

  Map get selectedWarehouse => _selectedWarehouse;
  set selectedWarehouse(Map value) {
    _selectedWarehouse = value;
    notifyListeners();
  }

  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  WarehouseProvider() {
    initialize();
  }

  void initialize() async {
    isLoading = true;

    await getWarehouses();

    isLoading = false;
  }

  Future<void> getWarehouses() async {
    var res = await HttpService.get(warehouse);

    if (res['status'] == Result.success) {
      warehouses = res['data'];
    }
  }
}
