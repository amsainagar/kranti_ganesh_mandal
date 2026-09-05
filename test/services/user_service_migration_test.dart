import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kranti_ganesh_mandal/models/app_role.dart';
import 'package:kranti_ganesh_mandal/models/user_status.dart';
import 'package:kranti_ganesh_mandal/services/hive_service.dart';
import 'package:kranti_ganesh_mandal/services/user_service.dart';

void main() {
  late Directory tempDir;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    tempDir = await Directory.systemTemp.createTemp('kgm_user_migration');

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/path_provider'),
      (methodCall) async => tempDir.path,
    );

    await HiveService.instance.init();
    await HiveService.instance.openBox(HiveBoxNames.users);

    await HiveService.instance.put(
      HiveBoxNames.users,
      UserService.defaultSuperAdminId,
      {
        'id': UserService.defaultSuperAdminId,
        'name': 'Role-Admin',
        'mobile': '9845501060',
        'password': '55555',
        'role': AppRole.admin,
        'createdAt': '2026-01-01T00:00:00.000',
        'updatedAt': '2026-01-01T00:00:00.000',
      },
    );

    await HiveService.instance.put(HiveBoxNames.users, 'legacy-user', {
      'id': 'legacy-user',
      'name': 'Legacy User',
      'mobile': '9000111111',
      'password': '1111',
      'role': AppRole.user,
      'createdAt': '2026-01-01T00:00:00.000',
      'updatedAt': '2026-01-01T00:00:00.000',
    });

    await UserService.instance.init();
  });

  tearDownAll(() async {
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  test('migrates legacy super admin credentials and role', () {
    final admin = UserService.instance.findByMobile('9845501060');

    expect(admin, isNotNull);
    expect(admin!['password'], UserService.defaultSuperAdminPassword);
    expect(admin['name'], UserService.defaultSuperAdminName);
    expect(admin['role'], AppRole.superAdmin);
    expect(admin['status'], UserStatus.active);
  });

  test('migrates users without status to active', () {
    final legacy = UserService.instance
        .getAllUsers()
        .firstWhere((user) => user['id'] == 'legacy-user');

    expect(legacy['status'], UserStatus.active);
  });

  test('migration flags prevent duplicate work', () async {
    final before = UserService.instance.findByMobile('9845501060');

    await UserService.instance.init();

    final after = UserService.instance.findByMobile('9845501060');
    expect(after, equals(before));
  });
}
