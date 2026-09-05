import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kranti_ganesh_mandal/core/utils/name_formatter.dart';
import 'package:kranti_ganesh_mandal/core/widgets/name_text_field.dart';

void main() {
  testWidgets('formats name when focus leaves field', (tester) async {
    final controller = TextEditingController();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: NameTextField(
            controller: controller,
            decoration: const InputDecoration(labelText: 'Name'),
          ),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), 'ananth thakur');
    await tester.tapAt(const Offset(1, 300));
    await tester.pump();

    expect(controller.text, 'Ananth Thakur');
    controller.dispose();
  });

  testWidgets('onEditingComplete formats name', (tester) async {
    final controller = TextEditingController();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: NameTextField(
            controller: controller,
            decoration: const InputDecoration(labelText: 'Name'),
          ),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), 'kruti ManGESH Patil');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();

    expect(controller.text, NameFormatter.format('kruti ManGESH Patil'));
    controller.dispose();
  });
}
