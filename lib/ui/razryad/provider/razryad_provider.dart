import 'package:flutter/material.dart';
import 'package:supervisor/services/http_service.dart';

class RazryadProvider extends ChangeNotifier {
  List _razryads = [];
  List get razryads => _razryads;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  RazryadProvider() {
    initialize();
  }

  Future<void> initialize() async {
    await getRazryads();
  }

  Future<void> getRazryads() async {
    isLoading = true;

    var res = await HttpService.get(razryad);

    if (res['status'] == Result.success) {
      _razryads = res['data'];
      notifyListeners();
    }

    isLoading = false;
  }

  Future<void> createRazryad(
    Map<String, dynamic> data,
  ) async {
    isLoading = true;

    var res = await HttpService.post(razryad, data);

    if (res['status'] == Result.success) {
      await getRazryads();
    }

    isLoading = false;
  }

  Future<void> updateRazryad(
    int id,
    Map<String, dynamic> data,
  ) async {
    isLoading = true;

    var res = await HttpService.put(razryad, data);

    if (res['status'] == Result.success) {
      await getRazryads();
    }

    isLoading = false;
  }

  Future<void> deleteRazryad(
    int id,
  ) async {
    isLoading = true;

    var res = await HttpService.delete("$razryad/$id");

    if (res['status'] == Result.success) {
      await getRazryads();
    }

    isLoading = false;
  }
}
