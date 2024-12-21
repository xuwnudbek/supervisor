import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:supervisor/services/http_service.dart';
import 'package:supervisor/ui/order/provider/order_provider.dart';
import 'package:supervisor/utils/extensions/map_extension.dart';
import 'package:supervisor/utils/extensions/string_extension.dart';
import 'package:supervisor/utils/widgets/custom_snackbars.dart';

class AddOrderProvider extends ChangeNotifier {
  final TextEditingController orderRasxodController = TextEditingController();
  List orderModels = [];

  final TextEditingController orderNameController = TextEditingController();
  final TextEditingController orderQuantityController = TextEditingController();

  DateTime? _startDate;
  DateTime? get startDate => _startDate;
  set startDate(DateTime? startDate) {
    _startDate = startDate;
    notifyListeners();
  }

  DateTime? _endDate;
  DateTime? get endDate => _endDate;
  set endDate(DateTime? endDate) {
    _endDate = endDate;
    notifyListeners();
  }

  List models = [];

  // Selected models's recipes
  List recipeData = [];

  // Models
  Map? _selectedModel;
  Map? get selectedModel => _selectedModel;
  set selectedModel(Map? value) {
    _selectedModel = value;
    selectedSubModel = {};
    selectedSize = {};
    selectedModelColor = {};

    notifyListeners();
  }

  Map? _selectedSubModel;
  Map? get selectedSubModel => _selectedSubModel;
  set selectedSubModel(Map? value) {
    _selectedSubModel = value;
    selectedSize = {};
    selectedModelColor = {};
    notifyListeners();
  }

  Map? _selectedSize;
  Map? get selectedSize => _selectedSize;
  set selectedSize(Map? value) {
    _selectedSize = value;
    notifyListeners();
  }

  Map? _selectedModelColor;
  Map? get selectedModelColor => _selectedModelColor;
  set selectedModelColor(Map? value) {
    _selectedModelColor = value;
    notifyListeners();
  }

  final TextEditingController quantityController = TextEditingController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(value) {
    _isLoading = value;
    notifyListeners();
  }

  AddOrderProvider(OrderProvider orderProvider) {
    models = orderProvider.models;
  }

  bool _isAddingModelToOrder = false;
  bool get isAddingModelToOrder => _isAddingModelToOrder;
  set isAddingModelToOrder(value) {
    _isAddingModelToOrder = value;
    notifyListeners();
  }

  Future<void> addModelToOrder(BuildContext context) async {
    if (selectedModel.isEmptyOrNull || selectedSubModel.isEmptyOrNull || selectedSize.isEmptyOrNull || selectedModelColor.isEmptyOrNull) {
      CustomSnackbars(context).warning("Iltimos, barcha maydonlarni to'ldiring");
      return;
    }

    if (quantityController.text.isNotValidNumber) {
      CustomSnackbars(context).warning("Iltimos, to'g'ri miqdor belgilang!");
      return;
    }

    isAddingModelToOrder = true;

    Map data = selectedModel!;
    data.addAll({"submodel": selectedSubModel} as Map);
    data.addAll({'size': selectedSize} as Map);
    data.addAll({'model_color': selectedModelColor} as Map);
    data.addAll({'quantity': quantityController.text} as Map);

    bool hasRecipe = await getRecipe(selectedModelColor!['id'], selectedSize!['id']);

    print(hasRecipe);

    if (hasRecipe) {
      orderModels.add(Map.from(data));
      quantityController.clear();
      notifyListeners();
    } else {
      CustomSnackbars(context).error("Retsept topilmadi!");
    }

    isAddingModelToOrder = false;
  }

  bool _isCreatingOrder = false;
  bool get isCreatingOrder => _isCreatingOrder;
  set isCreatingOrder(value) {
    _isCreatingOrder = value;
    notifyListeners();
  }

  Future<void> createOrder(BuildContext context) async {
    if (orderNameController.text.isEmpty || orderQuantityController.text.isNotValidNumber || startDate == null || endDate == null || orderModels.isEmpty) {
      CustomSnackbars(context).warning("Barcha maydonlar to'ldirilganini tekshiring!");
      return;
    }

    if (orderRasxodController.text.isEmpty) {
      CustomSnackbars(context).warning("Iltimos, rasxodni kiriting!");
      return;
    }

    isCreatingOrder = true;

    Map<String, dynamic> data = {
      "name": orderNameController.text,
      "quantity": orderQuantityController.text,
      "start_date": startDate!.toIso8601String().split("T").first,
      "end_date": endDate!.toIso8601String().split("T").first,
      "models": orderModels,
      "rasxod": orderRasxodController.text,
    };

    print("data: $data");

    var res = await HttpService.post(order, data);

    if (res['status'] == Result.success) {
      CustomSnackbars(context).success("Buyurtma muvofaqqiyatli yaratildi!");
      clearAllField();
    } else {
      CustomSnackbars(context).error("Buyurtmani yaratishda xatolik yuz berdi!");
    }

    isCreatingOrder = false;
  }

  bool _isGettingRecipes = false;
  bool get isGettingRecipes => _isGettingRecipes;
  set isGettingRecipes(value) {
    _isGettingRecipes = value;
    notifyListeners();
  }

  Future<bool> getRecipe(modelColorId, sizeId) async {
    isGettingRecipes = true;

    var res = await HttpService.get(showRecipe, param: {
      "model_color_id": modelColorId.toString(),
      "size_id": sizeId.toString(),
    });

    print("model: $modelColorId, size: $sizeId");

    if (res['status'] == Result.success) {
      recipeData.add(res['data'] ?? {});
      recipeData.removeWhere((element) => element?.isEmpty ?? true);
      notifyListeners();
      isGettingRecipes = false;
      return true;
    }

    isGettingRecipes = false;
    return false;
  }

  void clearAllField() {
    orderNameController.clear();
    orderQuantityController.clear();
    startDate = null;
    endDate = null;
    orderModels = [];
    selectedModel = null;
    selectedSubModel = null;
    selectedSize = null;
    selectedModelColor = null;
    quantityController.clear();

    recipeData.clear();
    orderRasxodController.clear();
    notifyListeners();
  }

  void clearDropDowns() {
    selectedModel = null;
    selectedSubModel = null;
    selectedSize = null;
    selectedModelColor = null;
    quantityController.clear();
  }

  void removeModelInOrder(Map model) {
    int index = orderModels.indexOf(model);
    orderModels.removeAt(index);
    notifyListeners();
  }
}
