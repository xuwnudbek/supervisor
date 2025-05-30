import 'package:flutter/material.dart';
import 'package:supervisor/services/http_service.dart';

class ItemProvider extends ChangeNotifier {
  final TextEditingController searchController = TextEditingController();

  bool _isLoading = false;
  bool _isCreating = false;
  bool _isUpdating = false;
  List _items = [];
  List _units = [];
  List _colors = [];
  List _itemTypes = [];

  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  bool get isCreating => _isCreating;
  set isCreating(bool value) {
    _isCreating = value;
    notifyListeners();
  }

  bool get isUpdating => _isUpdating;
  set isUpdating(bool value) {
    _isUpdating = value;
    notifyListeners();
  }

  List get items => _items;
  set items(List value) {
    _items = value;
    notifyListeners();
  }

  List get units => _units;
  set units(List value) {
    _units = value;
    notifyListeners();
  }

  List get colors => _colors;
  set colors(List value) {
    _colors = value;
    notifyListeners();
  }

  List get itemTypes => _itemTypes;
  set itemTypes(List value) {
    _itemTypes = value;
    notifyListeners();
  }

  ItemProvider();

  Future<void> initialize() async {
    await getItems();
    await getUnits();
    await getColors();
    await getItemTypes();

    searchController.addListener(() {
      notifyListeners();
    });
  }

  Future<void> getItems() async {
    isLoading = true;
    final res = await HttpService.get(item);

    if (res['status'] == Result.success) {
      items = res['data'] ?? [];
    }
    isLoading = false;
  }

  Future<Map> createItem(Map<String, dynamic> body) async {
    isCreating = true;
    final res = await HttpService.uploadWithImages(item, body: body);

    if (res['status'] == Result.success) {
      await getItems();
    }
    isCreating = false;

    return res;
  }

  Future<Map> updateItem(
    int id,
    Map<String, dynamic> body,
  ) async {
    isUpdating = true;
    final res = await HttpService.uploadWithImages("$item/$id", body: body, method: "patch");

    if (res['status'] == Result.success) {
      await getItems();
    }
    isUpdating = false;

    return res;
  }

  Future<void> deleteItem(int id) async {
    isLoading = true;
    final res = await HttpService.delete('$item/$id');

    if (res['status'] == Result.success) {
      await getItems();
    }
    isLoading = false;
  }

  Future<void> getUnits() async {
    isLoading = true;
    final res = await HttpService.get(unit);

    if (res['status'] == Result.success) {
      units = res['data'] ?? [];
    }
    isLoading = false;
  }

  Future<void> getColors() async {
    isLoading = true;
    final res = await HttpService.get(color);

    if (res['status'] == Result.success) {
      colors = res['data'] ?? [];
    }
    isLoading = false;
  }

  Future<void> getItemTypes() async {
    isLoading = true;
    final res = await HttpService.get(itemType);

    if (res['status'] == Result.success) {
      itemTypes = res['data'] ?? [];
    }
    isLoading = false;
  }
}
