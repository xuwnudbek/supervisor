extension StringExtension on String {
  int get toInt => int.parse(this);

  bool get isValidNumber => (int.tryParse(this) ?? 0) != 0;
  bool get isNotValidNumber => (int.tryParse(this) ?? 0) == 0;
}
