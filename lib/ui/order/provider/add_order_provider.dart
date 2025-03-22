import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supervisor/services/http_service.dart';
import 'package:supervisor/services/storage_service.dart';
import 'package:supervisor/ui/order/provider/order_provider.dart';
import 'package:supervisor/utils/extensions/list_extension.dart';
import 'package:supervisor/utils/extensions/string_extension.dart';
import 'package:supervisor/utils/themes/app_colors.dart';
import 'package:supervisor/utils/widgets/custom_input.dart';
import 'package:supervisor/utils/widgets/custom_snackbars.dart';

class AddOrderProvider extends ChangeNotifier {
  final TextEditingController orderNameController = TextEditingController();
  final TextEditingController orderRasxodController = TextEditingController();

  final TextEditingController instructionTitleController = TextEditingController();
  final FocusNode instructionTitleFocusNode = FocusNode();
  final TextEditingController instructionBodyController = TextEditingController();
  final FocusNode instructionBodyFocusNode = FocusNode();
  final TextEditingController orderCommentController = TextEditingController();
  final FocusScopeNode sizeScopeNodes = FocusScopeNode();
  final FocusScopeNode instructionScopeNodes = FocusScopeNode();

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

  late OrderProvider orderProvider;

  void initialize(OrderProvider orderProvider, {int? orderId, bool hasCopy = false}) async {
    this.orderProvider = orderProvider;
    models = orderProvider.models;
    contragents = orderProvider.contragents;
    items = orderProvider.items;
    materials = orderProvider.materials;

    Map? orderData;

    if (orderId != null) {
      var res = await HttpService.get("$order/$orderId");
      if (res['status'] == Result.success) {
        orderData = res['data'];
      }
    }

    if (hasCopy) {
      // read order from Clipboard
      try {
        if (selectedModel.isNotEmpty) {
          Clipboard.setData(ClipboardData(text: "{}"));
          return;
        }

        Map? orderCopy = json.decode((await Clipboard.getData('text/plain'))?.text ?? "{}");
        if (orderCopy != null) {
          orderData = orderCopy;
        }
      } catch (e) {
        print(e);
      }
    }

    if (orderData != null && orderData.isNotEmpty) {
      orderNameController.text = orderData['name'] ?? "";
      orderRasxodController.text = (orderData['rasxod'] ?? 0).toString();
      orderCommentController.text = orderData['comment'] ?? "";

      selectedModel = models.qaysiki(['id'], orderData['order_model']?['model']?['id']).firstOrNull ?? {};
      selectedMaterial = materials.qaysiki(['id'], orderData['order_model']?['material']?['id']).firstOrNull ?? {};
      selectedContragent = contragents.qaysiki(['id'], orderData['contragent']?['id']).firstOrNull ?? {};

      deadline = [
        if (orderData['start_date'] != null) DateTime.parse(orderData['start_date']),
        if (orderData['end_date'] != null) DateTime.parse(orderData['end_date']),
      ];

      for (var instruction in orderData['instructions'] ?? []) {
        instructions.add({
          "id": instruction['id'],
          "title": instruction['title'],
          "description": instruction['description'],
        });
      }

      for (var orderSubmodel in ((orderData['order_model']?['submodels'] ?? []) as List)) {
        selectSubmodel(orderSubmodel['submodel']);

        for (var orderRecipe in orderSubmodel['submodel']?['order_recipes'] ?? []) {
          addRecipe(
            id: orderRecipe['id'],
            orderSubmodel['submodel'] ?? {},
            item: orderRecipe['item'] ?? {},
            quantity: orderRecipe['quantity'] ?? 0,
          );
        }
      }

      for (var e in ((orderData['order_model']?['sizes'] ?? []) as List)) {
        selectSize(
          e['size'],
          id: e['id'],
          quantity: e['quantity'],
        );
      }

      Future.delayed(Duration(milliseconds: 1000), () {
        notifyListeners();
      });
    }
  }

  bool addRecipe(Map submodel, {int? id, Map? item, String quantity = ""}) {
    recipes.add({
      if (id != null) "id": id,
      "submodel": submodel,
      "item": item ?? {},
      "quantity": TextEditingController(text: quantity)
        ..addListener(() {
          notifyListeners();
        }),
    });

    notifyListeners();
    return true;
  }

  void removeRecipe(Map recipe) {
    if (recipes.qaysiki(['submodel'], recipe['submodel']).length == 1) {
      // recipes.qaysiki(['submodel'], recipe['submodel'])[0]['item'] = {};
      // recipes.qaysiki(['submodel'], recipe['submodel'])[0]['quantity'] = TextEditingController(text: "");
      // notifyListeners();
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
    List submodelRecipes = recipes.qaysiki(['submodel'], submodel);

    if (submodelRecipes.isNotEmpty) {
      submodelRecipes[index]['item'] = item;
      notifyListeners();
      return;
    }

    notifyListeners();
  }

  void selectSubmodel(Map value) {
    if (selectedSubmodels.where((e) => e['id'] == value['id']).isNotEmpty) {
      return;
    }

    selectedSubmodels.add(value);
    notifyListeners();
  }

  void removeSelectedSubmodel(Map value) {
    selectedSubmodels.removeWhere((e) => e['id'] == value['id']);
    recipes.removeWhere((e) => e['submodel']?['id'] == value['id']);
    notifyListeners();
  }

  void selectSize(value, {int quantity = 0, int? id}) {
    final FocusNode focusNode = FocusNode();

    selectedSizes.add({
      if (id != null) "id": id,
      "focusNode": focusNode,
      "size": value,
      "quantity": TextEditingController(text: "$quantity")
        ..addListener(() {
          notifyListeners();
        }),
    });
    notifyListeners();
  }

  void removeSelectedSize(value) {
    selectedSizes.removeWhere((e) => e['size']?['id'] == value['id']);
    notifyListeners();
  }

  void addInstruction(BuildContext context) {
    String title = instructionTitleController.text.trim();
    String body = instructionBodyController.text.trim();

    if (title.isEmpty || body.isEmpty) {
      CustomSnackbars(context).warning("Instruksiyani to'liq kiriting!");
      return;
    }

    if (instructions.isNotEmpty && instructions.where((e) => e['title'] == title).isNotEmpty) {
      CustomSnackbars(context).warning("Bunday instruksiya mavjud");
      return;
    }

    instructionTitleController.clear();
    instructionBodyController.clear();

    instructions.add({
      "id": null,
      "title": title,
      "description": body,
    });

    instructions = instructions.reversed.toList();
    notifyListeners();

    // Change focus to the first instruction title field
    instructionScopeNodes.requestFocus(instructionTitleFocusNode);
  }

  void removeInstruction(Map value) {
    instructions.remove(value);
    notifyListeners();
  }

  int get getSizesQuantity {
    if (selectedSizes.isNotEmpty) {
      return selectedSizes.map((e) => (double.tryParse(e['quantity'].text) ?? 0).toInt()).reduce((a, b) => a + b);
    }
    return 0;
  }

  num get getRecipesQuantity {
    if (recipes.isNotEmpty) {
      return recipes
          .map((e) {
            return (double.tryParse(e['quantity'].text) ?? 0) * (num.tryParse(e['item']?['price'] ?? "") ?? 0);
          })
          .reduce((a, b) => a + b)
          .toStringAsFixed(1)
          .toDouble;
    }
    return 0;
  }

  Future<void> addNewContragent(BuildContext context) async {
    final newContragentController = TextEditingController();

    var res = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Yangi buyurtmachi qo'shish"),
          content: Padding(
            padding: EdgeInsets.all(8),
            child: CustomInput(
              hint: "Buyurtmachi nomi",
              controller: newContragentController,
            ),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.red,
              ),
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: Text("Bekor qilish"),
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: primary.withValues(alpha: 0.1),
                foregroundColor: primary,
              ),
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text("Qo'shish"),
              ),
            ),
          ],
        );
      },
    );

    if (res == true) {
      orderProvider.contragents.add({
        "id": 0,
        "name": newContragentController.text,
      });
      contragents = orderProvider.contragents;

      selectedContragent = contragents.firstWhere((e) => e['id'] == 0) ?? {};
    }
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
      CustomSnackbars(context).warning("Buyurtma olish/topshirish sanasini tanlang!");
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
      "contragent_id": selectedContragent['id'] == 0 ? null : selectedContragent['id'],
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
              "id": e['id'],
              "submodel_id": e['submodel']?['id'],
              "item_id": e['item']['id'],
              "quantity": double.tryParse(e['quantity'].text) ?? 0,
            }),
      ],
    };

    Map<String, dynamic> res;

    int? orderId = StorageService.read('order_id');

    if (orderId != null) {
      res = await HttpService.patch("$order/$orderId", data);
    } else {
      res = await HttpService.post(order, data);
    }

    if (res['status'] == Result.success) {
      CustomSnackbars(context).success("Buyurtma muvaffaqiyatli ${orderId != null ? "yangilandi" : "yaratildi"}!");
      return true;
    }
    notifyListeners();

    return false;
  }

  void refreshUI() {
    notifyListeners();
  }
}
