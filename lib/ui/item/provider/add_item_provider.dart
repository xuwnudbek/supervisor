import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supervisor/services/http_service.dart';
import 'package:supervisor/ui/item/provider/item_provider.dart';
import 'package:supervisor/utils/widgets/custom_snackbars.dart';

class AddItemProvider extends ChangeNotifier {
  final ItemProvider provider;
  final Map? item;

  AddItemProvider({required this.provider, this.item}) {
    initialize();
  }

  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController codeController = TextEditingController();

  Map _selectedUnit = {};
  Map _selectedColor = {};
  Map _selectedType = {};
  XFile? _selectedImage;
  bool _isLoading = false;

  Map get selectedUnit => _selectedUnit;
  Map get selectedColor => _selectedColor;
  Map get selectedType => _selectedType;
  XFile? get selectedImage => _selectedImage;
  bool get isLoading => _isLoading;

  set selectedUnit(Map value) {
    _selectedUnit = value;
    notifyListeners();
  }

  set selectedColor(Map value) {
    _selectedColor = value;
    notifyListeners();
  }

  set selectedType(Map value) {
    _selectedType = value;
    notifyListeners();
  }

  set selectedImage(XFile? value) {
    _selectedImage = value;
    notifyListeners();
  }

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> showImagePicker() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImage = image;
    }
  }

  void initialize() {
    if (item != null && item!.isNotEmpty) {
      nameController.text = item!['name'];
      priceController.text = item!['price'];
      codeController.text = item!['code'] ?? "";
      selectedUnit = item!['unit'] ?? {};
      selectedColor = item!['color'] ?? {};
      selectedType = item!['type'] ?? {};
    }
  }

  void clear() {
    nameController.clear();
    priceController.clear();
    codeController.clear();
    selectedUnit = {};
    selectedColor = {};
    selectedType = {};
    selectedImage = null;
  }

  Future<void> saveItem(BuildContext context) async {
    if (provider.isLoading || provider.isCreating || provider.isUpdating) return;

    if (nameController.text.isEmpty || priceController.text.isEmpty || codeController.text.isEmpty || selectedUnit.isEmpty || selectedType.isEmpty || selectedColor.isEmpty) {
      CustomSnackbars(context).warning("Barcha maydonlarni to'ldiring");
      return;
    }

    final body = {
      "name": nameController.text,
      "price": priceController.text,
      "unit_id": selectedUnit['id'].toString(),
      "color_id": selectedColor['id'].toString(),
      "code": codeController.text,
      "type_id": selectedType['id'],
      "image": selectedImage?.path,
    }..removeWhere((key, value) => value == null);

    if (item != null && item!.isNotEmpty) {
      var res = await provider.updateItem(item!['id'], body);
      if (res['status'] == Result.success) {
        CustomSnackbars(context).success("Material o'zgartirildi");
      } else {
        CustomSnackbars(context).error("Xatolik yuz berdi");
      }
    } else {
      var res = await provider.createItem(body);
      if (res['status'] == Result.success) {
        CustomSnackbars(context).success("Material saqlandi");
        clear();
      } else {
        CustomSnackbars(context).error("Xatolik yuz berdi");
      }
    }
  }
}
