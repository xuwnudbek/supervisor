extension IntegerExtension on num {
  String get toCurrency {
    if (runtimeType == int) {
      String leftSide = toString();

      leftSide = leftSide.replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match match) {
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
      leftSide = leftSide.replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match match) {
        return "${match.group(1)},";
      });

      return "$leftSide.$rightSide"; // To'liq formatlangan natija
    }

    return toString();
  }
}
