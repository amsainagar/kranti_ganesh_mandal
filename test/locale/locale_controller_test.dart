import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kranti_ganesh_mandal/core/locale/locale_controller.dart';
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

  test('setLocale persists language code', () async {
    await LocaleController.instance.setLocale(const Locale('mr'));
    expect(LocaleController.instance.locale?.languageCode, 'mr');

    await LocaleController.instance.init();
    expect(LocaleController.instance.locale?.languageCode, 'mr');
  });

  test('toggleLocale switches between en and mr', () async {
    await LocaleController.instance.setLocale(const Locale('en'));
    await LocaleController.instance.toggleLocale();
    expect(LocaleController.instance.locale?.languageCode, 'mr');

    await LocaleController.instance.toggleLocale();
    expect(LocaleController.instance.locale?.languageCode, 'en');
  });
}
