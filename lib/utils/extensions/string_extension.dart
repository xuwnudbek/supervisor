import 'dart:ui';

import 'package:supervisor/services/http_service.dart';
import 'package:supervisor/services/storage_service.dart';

extension StringExtension on String {
  int get toInt => int.parse(this);

  bool get isValidNumber => (int.tryParse(this) ?? 0) != 0;
  bool get isNotValidNumber => (int.tryParse(this) ?? 0) == 0;

  Color get toHEXColor {
    if (length == 6) {
      return Color(int.parse('FF$this', radix: 16));
    }
    return const Color(0xFF000000);
  }

  double get toDouble => double.tryParse(this) ?? 0.0;

  String get toImageUrl {
    if (contains('rasmlar')) {
      /// Jamkhan
      return Uri.parse("https://omborapi.vizzano-apparel.uz:2021/media/$this").toString();
    } else if (contains('images')) {
      /// Qodirxon
      return Uri.parse("http://176.124.208.61:2025/$this").toString();
    }
    return Uri.parse('https://png.pngtree.com/png-clipart/20190925/original/pngtree-no-image-vector-illustration-isolated-png-image_4979075.jpg').toString();
  }
}
