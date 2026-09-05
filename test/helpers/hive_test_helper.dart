import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kranti_ganesh_mandal/core/auth/auth_controller.dart';
import 'package:kranti_ganesh_mandal/core/locale/locale_controller.dart';
import 'package:kranti_ganesh_mandal/services/hive_service.dart';

Future<Directory> setUpHiveTests() async {
  final tempDir = await Directory.systemTemp.createTemp('kgm_test');

  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
    const MethodChannel('plugins.flutter.io/path_provider'),
    (methodCall) async => tempDir.path,
  );

  await HiveService.instance.init();
  await LocaleController.instance.init();
  await AuthController.instance.init();

  return tempDir;
}

Future<void> tearDownHiveTests(Directory tempDir) async {
  await AuthController.instance.logout();
  if (await tempDir.exists()) {
    await tempDir.delete(recursive: true);
  }
}
