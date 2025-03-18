import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:supervisor/services/http_service.dart';
import 'package:supervisor/services/storage_service.dart';
import 'package:supervisor/utils/extensions/num_extension.dart';
import 'package:supervisor/utils/widgets/custom_snackbars.dart';

class ImportOrderProvider extends ChangeNotifier {
  FilePickerResult? _importOrderExcel;
  FilePickerResult? get importOrderExcel => _importOrderExcel;
  set importOrderExcel(FilePickerResult? value) {
    _importOrderExcel = value;
    notifyListeners();
  }

  List _importOrderList = [];
  List get importOrderList => _importOrderList;
  set importOrderList(List value) {
    _importOrderList = value;
    notifyListeners();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  //sekundomer
  int _seconds = 0;
  int get seconds => _seconds;
  set seconds(int value) {
    _seconds = value;
    notifyListeners();
  }

  bool _isEditable = false;
  bool get isEditable => _isEditable;
  set isEditable(bool value) {
    _isEditable = value;
    notifyListeners();
  }

  bool _isMoving = false;
  bool get isMoving => _isMoving;
  set isMoving(bool value) {
    _isMoving = value;
    notifyListeners();
  }

  bool _isCreating = false;
  bool get isCreating => _isCreating;
  set isCreating(bool value) {
    _isCreating = value;
    notifyListeners();
  }

  int _currentIndex = 0;
  int get currentIndex => _currentIndex;
  set currentIndex(int value) {
    _currentIndex = value;
    notifyListeners();
  }

  ImportOrderProvider();

  void removeOrderFromList(int index) {
    importOrderList.removeAt(index);
    notifyListeners();
  }

  Future<void> importOrder(BuildContext context) async {
    importOrderExcel = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'xls'],
      dialogTitle: "Modellar faylini tanlang",
    );

    if (importOrderExcel == null) return;

    isLoading = true;

    var res = await HttpService.uploadWithFile(
      importOrders,
      body: {
        "path": importOrderExcel!.files.first.path!,
      },
    );

    isLoading = false;

    importOrderExcel = null;

    if (res['status'] == Result.success) {
      if ((res['data']?['success'] ?? false) == true) {
        for (var model in ((res['data']?['data'] ?? []) as List)) {
          importOrderList.add({
            "model": TextEditingController(text: model['model'] ?? ""),
            "submodel": TextEditingController(text: model['submodel'] ?? ""),
            "quantity": TextEditingController(text: (num.tryParse("${model['quantity'] ?? 0}")?.toCurrency ?? "0")),
            "model_price": TextEditingController(text: (num.tryParse("${model['price'] ?? 0}")?.toCurrency ?? "0")),
            "model_summa": TextEditingController(text: (num.tryParse("${model['model_summa'] ?? 0}")?.toCurrency ?? "0")),
            "sizes": ((model['sizes'] ?? []) as List).map((e) => TextEditingController(text: e)).toList(),
            "images": model['images'] ?? [],
          });
        }

        CustomSnackbars(context).success("Modellar muvaffaqiyatli yuklandi!");
      } else {
        importOrderList = [];
        CustomSnackbars(context).error("Moderllarni yuklashda xatolik yuz berdi!");
      }
    } else {
      importOrderList = [];
      CustomSnackbars(context).error("Moderllarni yuklashda xatolik yuz berdi!");
    }

    notifyListeners();
  }

  Future<void> createOrders(BuildContext context) async {
    isCreating = true;

    for (var model in importOrderList) {
      if ((model['status'] ?? false) == true) continue;

      Map<String, dynamic> order = {
        "model": model['model'].text,
        "submodel": model['submodel'].text,
        "quantity": num.tryParse(model['quantity'].text.replaceAll(",", "")) ?? 0,
        "price": num.tryParse(model['model_price'].text.replaceAll(",", "")) ?? 0,
        "model_summa": num.tryParse(model['model_summa'].text.replaceAll(",", "")) ?? 0,
        "sizes": (model['sizes'] as List).map((e) => e.text).toList(),
        "images": model['images'] ?? [],
      };

      var res = await HttpService.uploadWithImages(
        orderStore,
        body: order,
      );

      if (res['status'] == Result.success) {
        HttpService.sendToBot(res['body'] ?? "Null");

        model['status'] = true;
        currentIndex++;
        StorageService.write("haveAnyChanges", true);
      } else {
        model['status'] = false;
      }
    }

    currentIndex = 0;
    isCreating = false;
  }
}
