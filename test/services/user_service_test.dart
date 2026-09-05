import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:kranti_ganesh_mandal/models/app_role.dart';
import 'package:kranti_ganesh_mandal/models/user_status.dart';
import 'package:kranti_ganesh_mandal/services/user_service.dart';
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

  test('seeds default super admin', () {
    final admin = UserService.instance.findByMobile('9845501060');

    expect(admin, isNotNull);
    expect(admin!['name'], 'Ananth');
    expect(admin['role'], AppRole.superAdmin);
    expect(admin['status'], UserStatus.active);
  });

  test('isDefaultSuperAdmin identifies seeded account', () {
    expect(
      UserService.isDefaultSuperAdmin(UserService.defaultSuperAdminId),
      isTrue,
    );
    expect(UserService.isDefaultSuperAdmin('other'), isFalse);
  });

  test('saveUser enforces super admin role and status', () async {
    await UserService.instance.saveUser({
      'id': UserService.defaultSuperAdminId,
      'name': 'Changed Name',
      'mobile': '9845501060',
      'password': '5555',
      'role': AppRole.admin,
      'status': UserStatus.inactive,
    });

    final admin = UserService.instance.findByMobile('9845501060');
    expect(admin!['role'], AppRole.superAdmin);
    expect(admin['status'], UserStatus.active);
  });

  test('findByMobile returns registered user', () async {
    await UserService.instance.saveUser({
      'id': 'user-1',
      'name': 'Test User',
      'mobile': '9111111111',
      'password': '4321',
      'role': AppRole.user,
      'status': UserStatus.active,
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    });

    expect(UserService.instance.findByMobile('9111111111')?['name'], 'Test User');
    expect(UserService.instance.findByMobile('0000000000'), isNull);
  });

  test('deleteUser removes record', () async {
    await UserService.instance.saveUser({
      'id': 'delete-me',
      'name': 'Delete Me',
      'mobile': '9222222222',
      'password': '4321',
      'role': AppRole.user,
      'status': UserStatus.active,
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    });

    await UserService.instance.deleteUser('delete-me');
    expect(UserService.instance.findByMobile('9222222222'), isNull);
  });

  test('getAllUsers returns every stored user', () async {
    await UserService.instance.saveUser({
      'id': 'user-a',
      'name': 'User A',
      'mobile': '9555555555',
      'password': '4321',
      'role': AppRole.user,
      'status': UserStatus.active,
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    });

    final users = UserService.instance.getAllUsers();
    expect(users.any((user) => user['id'] == 'user-a'), isTrue);
    expect(users.any((user) => user['id'] == UserService.defaultSuperAdminId), isTrue);
  });
}
