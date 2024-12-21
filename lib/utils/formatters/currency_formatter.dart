import 'package:flutter/services.dart';

class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String newText = newValue.text;

    if (newText.isEmpty) {
      return const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
    }

    String result = parseToCurrency(newText);

    return TextEditingValue(
      text: result,
      selection: TextSelection.collapsed(offset: result.length),
    );
  }
}

String parseToCurrency(String value) {
  if (value.contains(".") && value.split(".")[1].isNotEmpty) {
    value = double.parse(value.replaceAll(",", "")).toStringAsFixed(value.split(".")[1].length <= 4 ? value.split(".")[1].length : 4);

    String leftSide = value.split(".")[0];
    String rightSide = value.split(".")[1];

    String revLeftSide = String.fromCharCodes(leftSide.codeUnits.reversed);
    String result = "";

    for (int i = 0; i < revLeftSide.length; i++) {
      if (i % 3 == 0 && i != 0) {
        result += ",";
      }

      result += revLeftSide[i];
    }

    result = String.fromCharCodes(result.codeUnits.reversed);

    return "$result.${rightSide}";
  } else {
    if (value.contains(".")) {
      return value;
    }

    value = int.parse(value.replaceAll(",", "")).toString();

    String leftSide = value;
    String revLeftSide = String.fromCharCodes(leftSide.codeUnits.reversed);

    String result = "";
    for (int i = 0; i < revLeftSide.length; i++) {
      if (i % 3 == 0 && i != 0) {
        result += ",";
      }

      result += revLeftSide[i];
    }

    result = String.fromCharCodes(result.codeUnits.reversed);

    return result;
  }
}
