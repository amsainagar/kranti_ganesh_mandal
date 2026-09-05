import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kranti_ganesh_mandal/app.dart';
import 'package:kranti_ganesh_mandal/core/auth/auth_controller.dart';
import 'package:kranti_ganesh_mandal/l10n/app_localizations.dart';
import '../helpers/hive_test_helper.dart';

void main() {
  late Directory tempDir;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    tempDir = await setUpHiveTests();
  });

  tearDownAll(() async {
    await tearDownHiveTests(tempDir);
  });

  tearDown(() async {
    await AuthController.instance.logout();
  });

  testWidgets('Splash shows login screen', (tester) async {
    await tester.pumpWidget(const KrantiGaneshMandalApp());
    await tester.pump();

    expect(find.text('क्रांती गणेश सायगाव'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
  });

  testWidgets('App localizations delegate supports Marathi', (tester) async {
    expect(AppLocalizations.supportedLocales, contains(const Locale('mr')));
    expect(
      AppLocalizations.localizationsDelegates,
      contains(GlobalMaterialLocalizations.delegate),
    );
  });
}
