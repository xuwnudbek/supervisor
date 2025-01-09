import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:supervisor/services/http_service.dart';

class WarehouseProvider extends ChangeNotifier {
  // private properties
  List _warehouses = [];
  List _warehouseUsers = [];
  Map _selectedWarehouse = {};
  bool _isLoading = false;

  int sortIndex = 0;
  late Map<int, bool> sortingDirections;

  // getters & setters
  List get warehouses => _warehouses;
  set warehouses(List value) {
    _warehouses = value;
    notifyListeners();

    if (warehouses.isNotEmpty) {
      selectedWarehouse = warehouses.first;
    }
  }

  List get warehouseUsers => _warehouseUsers;
  set warehouseUsers(List value) {
    _warehouseUsers = value;
    notifyListeners();
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
    sortingDirections = {for (int i = 0; i < 6; i++) i: false};

    initialize();
  }

  void initialize() async {
    isLoading = true;

    await getWarehouses();
    await getWarehouseUsers();

    isLoading = false;
  }

  void sortBy(
    int index,
    String key, [
    bool isNumeric = false,
  ]) {
    List arr = selectedWarehouse['stoks'] ??= [];
    bool isAsc = sortingDirections[index] ?? false;

    if (isAsc) {
      arr.sort((a, b) {
        if (isNumeric) {
          return num.parse(a[key]).compareTo(num.parse(b[key]));
        }
        return (a[key]).compareTo(b[key]);
      });
    } else {
      arr.sort((a, b) {
        if (isNumeric) {
          return num.parse(b[key]).compareTo(num.parse(a[key]));
        }
        return (b[key]).compareTo(a[key]);
      });
    }

    sortingDirections[index] = !isAsc;
    sortIndex = index;

    selectedWarehouse['stocks'] = arr;
    notifyListeners();
  }

  Future<void> getWarehouses() async {
    var res = await HttpService.get(warehouseUrl);

    if (res['status'] == Result.success) {
      warehouses = res['data'];
    }
  }

  Future<void> getWarehouseUsers() async {
    var res = await HttpService.get('$user/warehouse');

    if (res['status'] == Result.success) {
      warehouseUsers = res['data'];
    }
  }
}
