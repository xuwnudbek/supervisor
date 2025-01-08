import 'package:flutter/material.dart';
import 'package:supervisor/services/http_service.dart';

class ModelProvider extends ChangeNotifier {
  List _models = [];
  List _colors = [];
  bool _isLoading = false;
  bool _isCreatingModel = false;
  bool _isUpdatingModel = false;

  ModelProvider() {
    initialize();
  }

  void initialize() async {
    isLoading = true;

    await getColors();
    await getModels();

    isLoading = false;
  }

  List get models => _models;
  set models(List models) {
    _models = models;
    notifyListeners();
  }

  List get colors => _colors;
  set colors(List colors) {
    _colors = colors;
    notifyListeners();
  }

  bool get isLoading => _isLoading;
  set isLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  bool get isCreatingModel => _isCreatingModel;
  set isCreatingModel(bool isCreatingModel) {
    _isCreatingModel = isCreatingModel;
    notifyListeners();
  }

  bool get isUpdatingModel => _isUpdatingModel;
  set isUpdatingModel(bool isUpdatingModel) {
    _isUpdatingModel = isUpdatingModel;
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
    isCreatingModel = true;

    var res = await HttpService.uploadWithImages(model, body: data);

    if (res['status'] == Result.success) {
      await getModels();
    }

    isCreatingModel = false;
  }

  Future<void> updateModel(int id, Map<String, dynamic> data) async {
    isUpdatingModel = true;

    var res = await HttpService.uploadWithImages("$model/$id", body: data, method: "patch");

    if (res['status'] == Result.success) {
      await getModels();
    }

    isUpdatingModel = false;
  }

  Future<void> deleteModel(int id) async {
    var res = await HttpService.delete("$model/$id");

    if (res['status'] == Result.success) {
      await getModels();
    }
  }
}
