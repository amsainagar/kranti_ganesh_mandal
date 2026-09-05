import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kranti_ganesh_mandal/models/app_role.dart';
import 'package:kranti_ganesh_mandal/services/hive_service.dart';
import 'package:kranti_ganesh_mandal/services/user_service.dart';

void main() {
  late Directory tempDir;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    tempDir = await Directory.systemTemp.createTemp('kgm_mobile_migration');

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
        'name': UserService.defaultSuperAdminName,
        'mobile': '9000000000',
        'password': UserService.defaultSuperAdminPassword,
        'role': AppRole.superAdmin,
        'createdAt': '2026-01-01T00:00:00.000',
        'updatedAt': '2026-01-01T00:00:00.000',
      },
    );

    await HiveService.instance.put(HiveBoxNames.users, 'missing-id-user', {
      'name': 'No Id',
      'mobile': '9000222222',
      'password': '1111',
      'role': AppRole.user,
    });

    await UserService.instance.init();
  });

  tearDownAll(() async {
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  test('migrates legacy super admin mobile to default', () {
    final admin = UserService.instance.findByMobile('9845501060');
    expect(admin, isNotNull);
    expect(admin!['mobile'], UserService.defaultSuperAdminMobile);
  });

  test('skips users without id during status migration', () {
    final users = UserService.instance.getAllUsers();
    final missingId = users.where((user) => user['mobile'] == '9000222222');
    expect(missingId, isNotEmpty);
    expect(missingId.first['status'], isNull);
  });
}
