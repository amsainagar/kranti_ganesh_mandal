import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:kranti_ganesh_mandal/core/auth/auth_controller.dart';
import 'package:kranti_ganesh_mandal/models/app_role.dart';
import 'package:kranti_ganesh_mandal/services/hive_service.dart';
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

  tearDown(() async {
    await AuthController.instance.logout();
  });

  group('validation', () {
    test('isValidMobile accepts 10 digits only', () {
      expect(AuthController.isValidMobile('9845501060'), isTrue);
      expect(AuthController.isValidMobile('98455 01060'), isTrue);
      expect(AuthController.isValidMobile('123'), isFalse);
    });

    test('isValidPassword accepts 4 digits only', () {
      expect(AuthController.isValidPassword('5555'), isTrue);
      expect(AuthController.isValidPassword('55555'), isFalse);
    });

    test('normalizeMobile strips non-digits', () {
      expect(AuthController.normalizeMobile('98-455-01060'), '9845501060');
    });
  });

  group('login', () {
    test('super admin can authenticate', () async {
      final error = await AuthController.instance.login(
        mobileInput: '9845501060',
        password: '5555',
      );

      expect(error, isNull);
      expect(AuthController.instance.isSuperAdmin, isTrue);
      expect(AuthController.instance.canManageUsers, isTrue);
      expect(AuthController.instance.displayName, 'Ananth');
    });

    test('rejects invalid mobile and password', () async {
      expect(
        await AuthController.instance.login(
          mobileInput: '123',
          password: '5555',
        ),
        'invalidMobile',
      );
      expect(
        await AuthController.instance.login(
          mobileInput: '9845501060',
          password: '12',
        ),
        'invalidPassword',
      );
    });

    test('rejects unknown and inactive users', () async {
      expect(
        await AuthController.instance.login(
          mobileInput: '9999999999',
          password: '1234',
        ),
        'invalidCredentials',
      );

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

      expect(
        await AuthController.instance.login(
          mobileInput: '8888888888',
          password: '1234',
        ),
        'accountInactive',
      );
    });

    test('rejects wrong password for known user', () async {
      expect(
        await AuthController.instance.login(
          mobileInput: '9845501060',
          password: '1234',
        ),
        'invalidCredentials',
      );
    });

    test('exposes role helpers for plain user', () async {
      await UserService.instance.saveUser({
        'id': 'plain-user',
        'name': 'Plain User',
        'mobile': '9777777777',
        'password': '7777',
        'role': AppRole.user,
        'status': 'active',
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      });

      await AuthController.instance.login(
        mobileInput: '9777777777',
        password: '7777',
      );

      expect(AuthController.instance.canEdit, isFalse);
      expect(AuthController.instance.canManageUsers, isFalse);
      expect(AuthController.instance.canViewGallery, isFalse);
      expect(AuthController.instance.userId, 'plain-user');
      expect(AuthController.instance.mobile, '9777777777');
    });
  });

  group('session', () {
    test('stores session in hive on login and clears on logout', () async {
      await AuthController.instance.login(
        mobileInput: '9845501060',
        password: '5555',
      );

      final session = HiveService.instance.get(
        HiveBoxNames.settings,
        'auth_session',
      );
      expect(session?['userId'], UserService.defaultSuperAdminId);

      await AuthController.instance.logout();
      expect(AuthController.instance.isLoggedIn, isFalse);
      expect(
        HiveService.instance.get(HiveBoxNames.settings, 'auth_session'),
        isNull,
      );
    });

    test('admin role has edit access but member does not', () async {
      await UserService.instance.saveUser({
        'id': 'admin-user',
        'name': 'Admin User',
        'mobile': '9000000001',
        'password': '1111',
        'role': AppRole.admin,
        'status': 'active',
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      });
      await UserService.instance.saveUser({
        'id': 'member-user',
        'name': 'Member User',
        'mobile': '9000000002',
        'password': '2222',
        'role': AppRole.member,
        'status': 'active',
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      });

      await AuthController.instance.login(
        mobileInput: '9000000001',
        password: '1111',
      );
      expect(AuthController.instance.canEdit, isTrue);
      expect(AuthController.instance.isSuperAdmin, isFalse);
      await AuthController.instance.logout();

      await AuthController.instance.login(
        mobileInput: '9000000002',
        password: '2222',
      );
      expect(AuthController.instance.canEdit, isFalse);
      expect(AuthController.instance.canViewGallery, isTrue);
    });
  });
}
