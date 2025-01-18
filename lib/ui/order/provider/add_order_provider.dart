import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:supervisor/services/http_service.dart';
import 'package:supervisor/ui/order/provider/order_provider.dart';
import 'package:supervisor/utils/extensions/list_extension.dart';
import 'package:supervisor/utils/extensions/string_extension.dart';
import 'package:supervisor/utils/widgets/custom_snackbars.dart';

class AddOrderProvider extends ChangeNotifier {
  final TextEditingController orderNameController = TextEditingController();
  final TextEditingController orderRasxodController = TextEditingController();

  final TextEditingController instructionTitleController =
      TextEditingController();
  final TextEditingController instructionBodyController =
      TextEditingController();
  final TextEditingController orderCommentController = TextEditingController();

  List models = [];
  List submodels = [];
  List sizes = [];
  List materials = [];
  List items = [];
  List contragents = [];

  List selectedSubmodels = [];
  List selectedSizes = [];
  List instructions = [];
  List recipes = [];

  // Private Fields
  List<DateTime> _deadline = [];
  Map _selectedModel = {};
  Map _selectedMaterial = {};
  Map _selectedContragent = {};

  bool _isLoading = false;
  bool _isCreatingOrder = false;

  // Getters and Setters
  List<DateTime> get deadline => _deadline;
  set deadline(List<DateTime> value) {
    _deadline = value;
    notifyListeners();
  }

  // Models
  Map get selectedModel => _selectedModel;
  set selectedModel(Map value) {
    _selectedModel = value;

    selectedSubmodels.clear();
    selectedSizes.clear();

    submodels = value['submodels'] ?? [];
    sizes = value['sizes'] ?? [];
    notifyListeners();
  }

  Map get selectedMaterial => _selectedMaterial;
  set selectedMaterial(Map value) {
    _selectedMaterial = value;
    notifyListeners();
  }

  // Models
  Map get selectedContragent => _selectedContragent;
  set selectedContragent(Map value) {
    _selectedContragent = value;
    notifyListeners();
  }

  bool get isLoading => _isLoading;
  set isLoading(value) {
    _isLoading = value;
    notifyListeners();
  }

  bool get isCreatingOrder => _isCreatingOrder;
  set isCreatingOrder(value) {
    _isCreatingOrder = value;
    notifyListeners();
  }

  AddOrderProvider(OrderProvider orderProvider) {
    models = orderProvider.models;
    contragents = orderProvider.contragents;
    items = orderProvider.items;
    materials = orderProvider.materials;
  }

  bool addRecipe(Map submodel) {
    recipes.add({
      "submodel": submodel,
      "item": {},
      "quantity": TextEditingController(text: "")
        ..addListener(() {
          notifyListeners();
        }),
    });
    notifyListeners();

    return true;
  }

  void removeRecipe(Map recipe) {
    if (recipes.qaysiki(['submodel'], recipe['submodel']).length == 1) {
      recipes.qaysiki(['submodel'], recipe['submodel'])[0]['item'] = {};
      recipes.qaysiki(['submodel'], recipe['submodel'])[0]['quantity'] =
          TextEditingController(text: "");
      notifyListeners();
      return;
    }

    recipes.removeWhere((e) => e == recipe);
    notifyListeners();
  }

  void selectItemForRecipe({
    required Map submodel,
    required Map item,
    required index,
  }) {
    var submodelRecipes =
        recipes.where((e) => e['submodel'] == submodel).toList();
    submodelRecipes[index]['item'] = item;
    notifyListeners();
  }

  void selectSubmodel(value) {
    selectedSubmodels.add(value);
    addRecipe(value);
    notifyListeners();
  }

  void removeSelectedSubmodel(value) {
    selectedSubmodels.remove(value);

    recipes.removeWhere((e) => e['submodel'] == value);

    notifyListeners();
  }

  void selectSize(value) {
    selectedSizes.add({
      "size": value,
      "quantity": TextEditingController(text: "")
        ..addListener(() {
          notifyListeners();
        }),
    });
    notifyListeners();
  }

  void removeSelectedSize(value) {
    selectedSizes.removeWhere((e) => e['size'] == value);
    notifyListeners();
  }

  void addInstruction(BuildContext context) {
    String title = instructionTitleController.text.trim();
    String body = instructionBodyController.text.trim();

    if (title.isEmpty || body.isEmpty) {
      CustomSnackbars(context).warning("Instruksiyani to'liq kiriting!");
      return;
    }

    if (instructions.isNotEmpty &&
        instructions.where((e) => e['title'] == title).isNotEmpty) {
      CustomSnackbars(context).warning("Bunday instruksiya mavjud");
      return;
    }

    instructionTitleController.clear();
    instructionBodyController.clear();

    instructions.add({
      "title": title,
      "description": body,
    });

    instructions = instructions.reversed.toList();
    notifyListeners();
  }

  void removeInstruction(Map value) {
    instructions.remove(value);
    notifyListeners();
  }

  int get getSizesQuantity {
    if (selectedSizes.isNotEmpty) {
      return selectedSizes
          .map((e) => (double.tryParse(e['quantity'].text) ?? 0).toInt())
          .reduce((a, b) => a + b);
    }
    return 0;
  }

  num get getRecipesQuantity {
    if (recipes.isNotEmpty) {
      return recipes
          .map((e) {
            return (double.tryParse(e['quantity'].text) ?? 0) *
                (num.tryParse(e['item']['price'] ?? "") ?? 0);
          })
          .reduce((a, b) => a + b)
          .toStringAsFixed(1)
          .toDouble;
    }
    return 0;
  }

  Future<bool?> createOrder(BuildContext context) async {
    if (orderNameController.text.isEmpty) {
      CustomSnackbars(context).warning("Buyurtma nomini kiriting!");
      return null;
    }

    if (selectedContragent.isEmpty) {
      CustomSnackbars(context).warning("Buyurtmachini tanlang/kiriting!");
      return null;
    }

    if (selectedMaterial.isEmpty) {
      CustomSnackbars(context).warning("Matoni tanlang!");
      return null;
    }

    if (deadline.isEmpty) {
      CustomSnackbars(context)
          .warning("Buyurtma olish/topshirish sanasini tanlang!");
      return null;
    }

    if (selectedModel.isEmpty) {
      CustomSnackbars(context).warning("Modelni tanlang!");
      return null;
    }

    if (selectedSubmodels.isEmpty) {
      CustomSnackbars(context).warning("Maxsulotni tanlang!");
      return null;
    }

    if (selectedSizes.isEmpty) {
      CustomSnackbars(context).warning("Kamida 1 ta o'lchamni tanlang!");
      return null;
    }

    if (orderCommentController.text.isEmpty) {
      CustomSnackbars(context).warning("Buyurtma uchun izoh yozmadingiz!");
      return null;
    }

    isCreatingOrder = true;

    Map<String, dynamic> data = {
      "name": orderNameController.text,
      "quantity": getSizesQuantity,
      "start_date": deadline.firstOrNull.toString(),
      "end_date": deadline.lastOrNull.toString(),
      "rasxod": double.tryParse(orderRasxodController.text),
      "comment": orderCommentController.text,
      "contragent_id":
          selectedContragent['id'] == 0 ? null : selectedContragent['id'],
      "contragent_name": selectedContragent['name'],
      "instructions": instructions,
      "model": {
        "material_id": selectedMaterial['id'],
        "id": selectedModel['id'],
        "submodels": [
          ...selectedSubmodels.map((e) => e['id']),
        ],
        "sizes": [
          ...selectedSizes.map((e) => {
                "id": e['size']['id'],
                "quantity": double.tryParse(e['quantity'].text) ?? 0,
              }),
        ],
      },
      "recipes": [
        ...recipes.map((e) => {
              "submodel_id": e['submodel']['id'],
              "item_id": e['item']['id'],
              "quantity": double.tryParse(e['quantity'].text) ?? 0,
            }),
      ],
    };

    print(data);

    var res = await HttpService.post(order, data);

    if (res['status'] == Result.success) {
      CustomSnackbars(context).success("Buyurtma muvaffaqiyatli yaratildi!");
      return true;
    }
    notifyListeners();

    return false;
  }
}

/*
{
  "name": "OrderName",
  "quantity": 100,
  "start_date": "2021-01-01",
  "end_date": "2021-01-02",
  "rasxod": 0.1,
  "final_product_name": "POLNOTA 1",
  "comment": "Order Comment",
  "contragent_id": 1,
  "contragent_name": "Contragent Name",
  "instructions": [
      {
          "title": "Instruction Name",
          "description": "Instruction Description"
      }
  ],
  "model": {
      "id": 1,
      "material_id": 1,
      "submodel": [
          1,
          2,
          3,
          4
      ],
      "sizes": [
          {
              "id": 1,
              "quantity": 10
          }
      ]
  }
}
*/
