import 'package:flutter/material.dart';
import 'package:supervisor/services/storage_service.dart';
import 'package:supervisor/ui/color/color_page.dart';
import 'package:supervisor/ui/department/department_page.dart';
import 'package:supervisor/ui/item/item_page.dart';
import 'package:supervisor/ui/model/model_page.dart';
import 'package:supervisor/ui/order/order_page.dart';
import 'package:supervisor/ui/razryad/razryad_page.dart';
import 'package:supervisor/ui/warehouse/warehouse_page.dart';

class HomeProvider extends ChangeNotifier {
  final List<Map> menu = [
    {
      'title': 'Buyurtmalar',
      'view': const OrderPage(),
    },
    {
      'title': 'Modellar',
      'view': const ModelPage(),
    },
    {
      'title': 'Maxsulotlar',
      'view': const ItemPage(),
    },
    {
      'title': 'Ranglar',
      'view': const ColorPage(),
    },
    {
      'title': 'Razryadlar',
      'view': const RazryadPage(),
    },
    {
      'title': 'Departmentlar',
      'view': const DepartmentPage(),
    },
    {
      'title': 'Omborlar',
      'view': const WarehousePage(),
    },
  ];

  Widget get selectedView => menu[selectedIndex]['view'];

  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;
  set selectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  HomeProvider();

  void initialize() async {
    notifyListeners();
  }

  Future logout() async {
    StorageService.clear();
  }
}
