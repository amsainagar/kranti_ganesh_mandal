import 'package:flutter/material.dart';
import 'package:kranti_ganesh_mandal/core/utils/name_formatter.dart';

class NameTextField extends StatelessWidget {
  const NameTextField({
    super.key,
    required this.controller,
    required this.decoration,
    this.maxLines = 1,
    this.textCapitalization = TextCapitalization.words,
  });

  final TextEditingController controller;
  final InputDecoration decoration;
  final int maxLines;
  final TextCapitalization textCapitalization;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: decoration,
      maxLines: maxLines,
      textCapitalization: textCapitalization,
      onEditingComplete: () => NameFormatter.applyToController(controller),
      onTapOutside: (_) => NameFormatter.applyToController(controller),
    );
  }
}
