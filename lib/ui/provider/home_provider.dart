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
      'title': 'Bosh sahifa',
      'icon': Icons.home,
      'view': Container(),
    },
    {
      'title': 'Buyurtmalar',
      'icon': Icons.shopping_cart,
      'view': const OrderPage(),
    },
    {
      'title': 'Modellar',
      'icon': Icons.shopping_cart,
      'view': const ModelPage(),
    },
    {
      'title': 'Maxsulotlar',
      'icon': Icons.shopping_cart,
      'view': const ItemPage(),
    },
    {
      'title': 'Ranglar',
      'icon': Icons.shopping_cart,
      'view': const ColorPage(),
    },
    {
      'title': 'Razryadlar',
      'icon': Icons.shopping_cart,
      'view': const RazryadPage(),
    },
    {
      'title': 'Departmentlar',
      'icon': Icons.shopping_cart,
      'view': const DepartmentPage(),
    },
    {
      'title': 'Omborlar',
      'icon': Icons.shopping_cart,
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
