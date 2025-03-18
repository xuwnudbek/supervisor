import 'package:flutter/material.dart';
import 'package:supervisor/services/http_service.dart';

class DepartmentProvider extends ChangeNotifier {
  // private properties
  List _departments = [];
  bool _isLoading = false;

  // getters and setters
  List get departments => _departments;
  set departments(List value) {
    _departments = value;
    notifyListeners();
  }

  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  DepartmentProvider() {
    initialize();
  }

  void initialize() async {
    isLoading = true;

    await getDepartments();

    isLoading = false;
  }

  Future<void> getDepartments() async {
    var res = await HttpService.get(department);

    if (res['status'] == Result.success) {
      departments = res['data'];
    }
  }
}
