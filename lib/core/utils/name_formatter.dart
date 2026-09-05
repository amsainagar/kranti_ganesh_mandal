import 'package:flutter/material.dart';

abstract final class NameFormatter {
  static final RegExp _letter = RegExp(r'[A-Za-z]');

  static String format(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return trimmed;

    return trimmed
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .map(_capitalizeWord)
        .join(' ');
  }

  static void applyToController(TextEditingController controller) {
    final formatted = format(controller.text);
    if (formatted == controller.text) return;
    controller.value = TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  static String _capitalizeWord(String word) {
    if (word.isEmpty) return word;

    final buffer = StringBuffer();
    var capitalizeNext = true;

    for (final codeUnit in word.codeUnits) {
      final char = String.fromCharCode(codeUnit);
      if (_letter.hasMatch(char)) {
        buffer.write(capitalizeNext ? char.toUpperCase() : char.toLowerCase());
        capitalizeNext = false;
      } else {
        buffer.write(char);
        if (char == '-' || char == '\'') {
          capitalizeNext = true;
        }
      }
    }

    return buffer.toString();
  }
}
