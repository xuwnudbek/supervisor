import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:supervisor/services/http_service.dart';

class ImportOrderProvider extends ChangeNotifier {
  FilePickerResult? _importOrderExcel;
  FilePickerResult? get importOrderExcel => _importOrderExcel;
  set importOrderExcel(FilePickerResult? value) {
    _importOrderExcel = value;
    notifyListeners();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  ImportOrderProvider();

  Future<void> importOrder() async {
    importOrderExcel = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'xls'],
      dialogTitle: "Modellar faylini tanlang",
    );

    if (importOrderExcel == null) return;

    var res = await HttpService.uploadWithFile(
      "/orders/import",
      body: {
        "path": importOrderExcel!.files.first.path!,
        "name": importOrderExcel!.files.first.name,
      },
    );

    if (res['status'] == Result.success) {
      
    } else {}

    notifyListeners();
  }
}
