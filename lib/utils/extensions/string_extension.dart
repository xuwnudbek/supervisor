import 'dart:ui';

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
}
