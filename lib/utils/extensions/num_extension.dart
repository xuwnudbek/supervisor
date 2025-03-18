import 'package:flutter/material.dart' show Colors, Color;

extension IntegerExtension on num {
  String get toCurrency {
    if (runtimeType == int) {
      String leftSide = toString();

      leftSide = leftSide.replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (Match match) {
        return "${match.group(1)},";
      });

      return leftSide;
    }

    if (runtimeType == double) {
      String text = toStringAsFixed(2);
      List<String> parts = text.split(".");

      String leftSide = parts[0]; // Butun qismi
      String rightSide = parts[1]; // Kasr qismi

      // Har uch raqamdan keyin vergul qo'shish
      leftSide = leftSide.replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (Match match) {
        return "${match.group(1)},";
      });

      return "$leftSide.$rightSide"; // To'liq formatlangan natija
    }

    return toString();
  }

  Color itemStatus(double minQuantity) {
    double p = (this / minQuantity) * 100 - 100;

    if (p < -20) return Colors.red.withValues(alpha: 0.7);
    if (p < 0) return Colors.red..withValues(alpha: 0.8);
    if (p < 50) return Colors.lime.withValues(alpha: 0.8);
    return Colors.transparent;
  }

  // if the num is int then return it as int
  // if the num is double then return it as double
  num get fromNum {
    if (toInt() == this) {
      return toInt();
    }

    return double.parse(toString());
  }
}
