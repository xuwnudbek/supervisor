import 'package:flutter/material.dart';
import 'package:supervisor/services/storage_service.dart';
import 'package:supervisor/ui/model/model_page.dart';
import 'package:supervisor/ui/order/order_page.dart';

class HomeProvider extends ChangeNotifier {
  final List<Map> menu = [
    {
      'title': 'Home',
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
