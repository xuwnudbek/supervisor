import 'package:flutter/material.dart';
import 'package:supervisor/services/http_service.dart';

class ModelDetailsProvider extends ChangeNotifier {
  Map model;

  Map selectedSubmodel = {};
  Map selectedSize = {};
  Map selectedColor = {};
  List recipes = [];

  void selectSubmodel(int value) {
    selectedSubmodel = (model['submodels'] as List).firstWhere((submodel) => submodel['id'] == value);
    selectedSize = {};
    selectedColor = {};
    notifyListeners();
  }

  void selectSize(int value) async {
    selectedSize = (selectedSubmodel['sizes'] as List).firstWhere((size) => size['id'] == value);
    notifyListeners();

    isLoading = true;
    notifyListeners();

    await getRecipes();

    isLoading = false;
    notifyListeners();
  }

  void selectColor(int value) async {
    selectedColor = (selectedSubmodel['model_colors'] as List).firstWhere((color) => color['id'] == value);
    notifyListeners();

    isLoading = true;
    notifyListeners();

    await getRecipes();

    isLoading = false;
    notifyListeners();
  }

  bool isLoading = false;

  ModelDetailsProvider({required this.model}) {
    initialize();
  }

  void initialize() async {
    isLoading = true;
    notifyListeners();

    await getModel();

    isLoading = false;
    notifyListeners();
  }

  Future<void> getModel() async {
    isLoading = true;
    notifyListeners();

    var res = await HttpService.get("$model/${model['id']}");

    if (res['status'] == Result.success) {
      model = res['data'];
      notifyListeners();
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> getRecipes() async {
    if (selectedColor.isEmpty || selectedSize.isEmpty) return;

    var res = await HttpService.get(recipe, param: {
      'model_color_id': "${selectedColor['id']}",
      'size_id': "${selectedSize['id']}",
    });

    if (res['status'] == Result.success) {
      recipes = res['data'];
      notifyListeners();
    }
  }

  Future<void> addRecipe(Map<String, dynamic> data) async {
    var res = await HttpService.post(recipe, data);

    if (res['status'] == Result.success) {
      await getRecipes();
    }
  }

  Future<void> editRecipe(int id, Map<String, dynamic> data) async {
    var res = await HttpService.patch("$recipe/$id", data);

    if (res['status'] == Result.success) {
      await getRecipes();
    }
  }

  Future<void> deleteRecipe(int id) async {
    var res = await HttpService.delete("$recipe/$id");

    if (res['status'] == Result.success) {
      await getModel();
    }
  }

  void resetAll() {
    selectedSubmodel = {};
    selectedSize = {};
    selectedColor = {};
    notifyListeners();
  }
}
