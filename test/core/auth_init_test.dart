import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kranti_ganesh_mandal/core/auth/auth_controller.dart';
import 'package:kranti_ganesh_mandal/models/app_role.dart';
import 'package:kranti_ganesh_mandal/services/hive_service.dart';
import 'package:kranti_ganesh_mandal/services/user_service.dart';
import '../helpers/hive_test_helper.dart';

void main() {
  late Directory tempDir;

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    tempDir = await Directory.systemTemp.createTemp('kgm_auth_init');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/path_provider'),
      (methodCall) async => tempDir.path,
    );
    await HiveService.instance.init();
    await UserService.instance.init();
    await AuthController.instance.logout();
  });

  tearDown(() async {
    await AuthController.instance.logout();
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  test('init clears session for inactive user', () async {
    await UserService.instance.saveUser({
      'id': 'inactive-user',
      'name': 'Inactive User',
      'mobile': '8888888888',
      'password': '1234',
      'role': AppRole.user,
      'status': 'inactive',
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    });

    await HiveService.instance.put(HiveBoxNames.settings, 'auth_session', {
      'userId': 'inactive-user',
    });

    await AuthController.instance.init();

    expect(AuthController.instance.isLoggedIn, isFalse);
    expect(
      HiveService.instance.get(HiveBoxNames.settings, 'auth_session'),
      isNull,
    );
  });

  test('init restores active session', () async {
    await AuthController.instance.login(
      mobileInput: '9845501060',
      password: '5555',
    );
    await AuthController.instance.logout();

    await HiveService.instance.put(HiveBoxNames.settings, 'auth_session', {
      'userId': UserService.defaultSuperAdminId,
    });

    await AuthController.instance.init();

    expect(AuthController.instance.isLoggedIn, isTrue);
    expect(AuthController.instance.isSuperAdmin, isTrue);
  });
}
