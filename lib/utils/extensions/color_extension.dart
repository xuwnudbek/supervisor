import 'package:flutter/material.dart';

extension ColorExtension on Color {
  String get toHEX {
    return value.toRadixString(16).substring(2).toUpperCase();
  }
}
