import 'package:flutter/material.dart';

extension ColorExtension on Color {
  String get toHEX {
    // ignore: deprecated_member_use
    return value.toRadixString(16).substring(2).toUpperCase();
  }
}
