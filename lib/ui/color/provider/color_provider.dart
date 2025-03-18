import 'package:flutter/material.dart';
import 'package:supervisor/services/http_service.dart';

class ColorProvider extends ChangeNotifier {
  List _colors = [];
  List get colors => _colors;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  ColorProvider() {
    initialize();
  }

  Future<void> initialize() async {
    await getColors();
  }

  Future<void> getColors() async {
    isLoading = true;

    var res = await HttpService.get(color);

    if (res['status'] == Result.success) {
      _colors = res['data'];
      notifyListeners();
    }

    isLoading = false;
  }

  Future<void> createColor(
    Map<String, dynamic> data,
  ) async {
    isLoading = true;

    var res = await HttpService.post(color, data);

    if (res['status'] == Result.success) {
      await getColors();
    }

    isLoading = false;
  }

  Future<void> updateColor(
    int id,
    Map<String, dynamic> data,
  ) async {
    isLoading = true;

    var res = await HttpService.patch("$color/$id", data);

    if (res['status'] == Result.success) {
      await getColors();
    }

    isLoading = false;
  }

  Future<void> deleteColor(
    int id,
  ) async {
    isLoading = true;

    var res = await HttpService.delete("$color/$id");

    if (res['status'] == Result.success) {
      await getColors();
    }

    isLoading = false;
  }
}
