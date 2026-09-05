import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:kranti_ganesh_mandal/core/router/page_transitions.dart';

void main() {
  testWidgets('fade transition shows child', (tester) async {
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          pageBuilder: (context, state) =>
              PageTransitions.fade(state, const Text('Fade Child')),
        ),
      ],
    );

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));

    expect(find.text('Fade Child'), findsOneWidget);
  });

  testWidgets('slide transition shows child', (tester) async {
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          pageBuilder: (context, state) =>
              PageTransitions.slide(state, const Text('Slide Child')),
        ),
      ],
    );

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Slide Child'), findsOneWidget);
  });
}
