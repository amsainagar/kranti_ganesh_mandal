import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kranti_ganesh_mandal/core/widgets/login_text_field.dart';

void main() {
  testWidgets('renders centered label and text field', (tester) async {
    final controller = TextEditingController();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LoginTextField(
            controller: controller,
            label: 'Mobile Number',
            keyboardType: TextInputType.phone,
            maxLength: 10,
            obscureText: true,
          ),
        ),
      ),
    );

    expect(find.text('Mobile Number'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);

    await tester.enterText(find.byType(TextField), '1234');
    expect(controller.text, '1234');
  });
}
