import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kranti_ganesh_mandal/core/utils/name_formatter.dart';

void main() {
  test('format title-cases each word', () {
    expect(NameFormatter.format('ananth thakur'), 'Ananth Thakur');
    expect(
      NameFormatter.format('JitenDRA manoHar saxena'),
      'Jitendra Manohar Saxena',
    );
    expect(
      NameFormatter.format('kruti ManGESH Patil'),
      'Kruti Mangesh Patil',
    );
    expect(NameFormatter.format('  '), '');
    expect(NameFormatter.format('mary-jane o\'connor'), 'Mary-Jane O\'Connor');
  });

  test('applyToController updates controller text', () {
    final controller = TextEditingController(text: 'ananth thakur');
    NameFormatter.applyToController(controller);
    expect(controller.text, 'Ananth Thakur');
    controller.dispose();
  });

  test('applyToController skips unchanged text', () {
    final controller = TextEditingController(text: 'Ananth Thakur');
    NameFormatter.applyToController(controller);
    expect(controller.text, 'Ananth Thakur');
    controller.dispose();
  });
}
