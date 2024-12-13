import 'package:flutter/material.dart';
import 'package:supervisor/services/http_service.dart';

class ModelProvider extends ChangeNotifier {
  List _models = [];
  List get models => _models;
  set models(List models) {
    _models = models;
    notifyListeners();
  }

  List _colors = [];
  List get colors => _colors;
  set colors(List colors) {
    _colors = colors;
    notifyListeners();
  }

  bool isLoading = false;

  ModelProvider() {
    initialize();
  }

  void initialize() async {
    isLoading = true;
    notifyListeners();

    await getColors();
    await getModels();

    isLoading = false;
    notifyListeners();
  }

  Future<void> getColors() async {
    var res = await HttpService.get(color);
    if (res['status'] == Result.success) {
      colors = res['data'];
    }
  }

  Future<void> getModels() async {
    var res = await HttpService.get(model);
    if (res['status'] == Result.success) {
      models = res['data'];
    }
  }

  Future<void> createModel(Map<String, dynamic> data) async {
    var res = await HttpService.post(model, data);

    if (res['status'] == Result.success) {
      await getModels();
    }
  }

  Future<void> updateModel(int id, Map<String, dynamic> data) async {
    var res = await HttpService.patch("$model/$id", data);

    if (res['status'] == Result.success) {
      await getModels();
    } else {
      print(res['data']);
    }
  }

  Future<void> deleteModel(int id) async {
    var res = await HttpService.delete("$model/$id");

    if (res['status'] == Result.success) {
      await getModels();
    }
  }
}
