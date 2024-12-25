import 'package:flutter/material.dart';
import 'package:supervisor/services/http_service.dart';
import 'package:supervisor/utils/widgets/custom_snackbars.dart';

class ModelDetailsProvider extends ChangeNotifier {
  Map modelData;

  Map selectedSubmodel = {};
  Map selectedSize = {};
  Map selectedColor = {};
  List recipes = [];

  void selectSubmodel(int value) {
    selectedSubmodel = (modelData['submodels'] as List).firstWhere((submodel) => submodel['id'] == value);
    selectedSize = {};
    selectedColor = {};
    notifyListeners();
  }

  void selectSize(int value) async {
    selectedSize = (selectedSubmodel['sizes'] as List).firstWhere((size) => size['id'] == value);
    notifyListeners();

    isLoading = true;
    notifyListeners();

    await getRecipe();

    isLoading = false;
    notifyListeners();
  }

  void selectColor(int value) async {
    selectedColor = (selectedSubmodel['model_colors'] as List).firstWhere((color) => color['id'] == value);
    notifyListeners();

    isLoading = true;
    notifyListeners();

    await getRecipe();

    isLoading = false;
    notifyListeners();
  }

  bool isLoading = false;

  ModelDetailsProvider({required this.modelData}) {
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

    var res = await HttpService.get("$model/${modelData['id']}");

    if (res['status'] == Result.success) {
      modelData = res['data'];
      notifyListeners();
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> getRecipe() async {
    if (selectedColor.isEmpty || selectedSize.isEmpty) return;

    var res = await HttpService.get(recipe, param: {
      'model_color_id': "${selectedColor['id']}",
      'size_id': "${selectedSize['id']}",
    });

    if (res['status'] == Result.success) {
      recipes = res['data'];
      print(recipes.length);
      notifyListeners();
    }
  }

  Future<void> addRecipe(Map<String, dynamic> data, {required BuildContext context}) async {
    var res = await HttpService.post(recipe, data);

    if (res['status'] == Result.success) {
      await getRecipe();

      CustomSnackbars(context).success("Retsept muvaffaqiyatli qo'shildi");
    } else {
      CustomSnackbars(context).error("Retsept qo'shishda xatolik yuz berdi");
    }
  }

  Future<void> editRecipe(int id, Map<String, dynamic> data, {required BuildContext context}) async {
    var res = await HttpService.patch("$recipe/$id", data);

    if (res['status'] == Result.success) {
      await getRecipe();

      CustomSnackbars(context).success("Retsept muvaffaqiyatli o'zgartirildi");
    } else {
      CustomSnackbars(context).error("Retsept o'zgartirishda xatolik yuz berdi");
    }
  }

  Future<void> deleteRecipe(int id, {required BuildContext context}) async {
    var res = await HttpService.delete("$recipe/$id");

    if (res['status'] == Result.success) {
      await getRecipe();
      CustomSnackbars(context).success("Retsept muvaffaqiyatli o'chirildi");
    } else {
      CustomSnackbars(context).error("Retsept o'chirishda xatolik yuz berdi");
    }
  }

  void resetAll() {
    selectedSubmodel = {};
    selectedSize = {};
    selectedColor = {};
    notifyListeners();
  }
}
