import 'package:flutter/material.dart';
import 'package:supervisor/ui/order/provider/order_provider.dart';
import 'package:supervisor/utils/widgets/custom_snackbars.dart';

class AddOrderProvider extends ChangeNotifier {
  final TextEditingController orderNameController = TextEditingController();
  final TextEditingController orderRasxodController = TextEditingController();

  final TextEditingController instructionTitleController = TextEditingController();
  final TextEditingController instructionBodyController = TextEditingController();
  final TextEditingController orderCommentController = TextEditingController();

  List models = [];
  List submodels = [];
  List sizes = [];
  List items = [];
  List contragents = [];

  List selectedSubmodels = [];
  List selectedSizes = [];
  List instructions = [];
  List recipes = [];

  // Private Fields
  List<DateTime> _deadline = [];
  Map _selectedModel = {};
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
  }

  double getSizesQuantity() {
    if (selectedSizes.isNotEmpty) {
      return selectedSizes.map((e) => e['quantity']).reduce((a, b) => a + b);
    }

    return 0.0;
  }

  void addRecipe(Map submodel) {
    recipes.add({
      "submodel": submodel,
      "item": {},
      "quantity": TextEditingController(text: "0"),
    });
    notifyListeners();
  }

  void removeRecipe(Map recipe) {
    recipes.removeWhere((e) => e == recipe);
    notifyListeners();
  }

  void selectItemForRecipe({
    required Map submodel,
    required Map item,
    required index,
  }) {
    var submodelRecipes = recipes.where((e) => e['submodel'] == submodel).toList();
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

    removeRecipe(value);

    notifyListeners();
  }

  void selectSize(value) {
    selectedSizes.add(value);
    notifyListeners();
  }

  void removeSelectedSize(value) {
    selectedSizes.remove(value);
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
      "title": title,
      "body": body,
    });

    instructions = instructions.reversed.toList();
    notifyListeners();
  }

  void removeInstruction(Map value) {
    instructions.remove(value);
    notifyListeners();
  }

  Future<void> createOrder(BuildContext context) async {
    // if (orderNameController.text.isEmpty || orderQuantityController.text.isNotValidNumber || startDate == null || endDate == null || orderModels.isEmpty) {
    //   CustomSnackbars(context).warning("Barcha maydonlar to'ldirilganini tekshiring!");
    //   return;
    // }

    // if (orderRasxodController.text.isEmpty) {
    //   CustomSnackbars(context).warning("Iltimos, rasxodni kiriting!");
    //   return;
    // }

    // isCreatingOrder = true;

    // Map<String, dynamic> data = {
    //   "name": orderNameController.text,
    //   "quantity": orderQuantityController.text,
    //   "start_date": startDate!.toIso8601String().split("T").first,
    //   "end_date": endDate!.toIso8601String().split("T").first,
    //   "models": orderModels,
    //   "rasxod": orderRasxodController.text,
    // };

    // var res = await HttpService.post(order, data);

    // if (res['status'] == Result.success) {
    //   CustomSnackbars(context).success("Buyurtma muvofaqqiyatli yaratildi!");
    //   clearAllField();
    // } else {
    //   CustomSnackbars(context).error("Buyurtmani yaratishda xatolik yuz berdi!");
    // }

    // isCreatingOrder = false;
  }
}
