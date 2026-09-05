import 'package:kranti_ganesh_mandal/models/app_role.dart';
import 'package:kranti_ganesh_mandal/models/user_status.dart';
import 'package:kranti_ganesh_mandal/services/hive_service.dart';

final class UserService {
  UserService._();
  static final UserService instance = UserService._();

  static const defaultSuperAdminId = 'admin-default';
  static const defaultSuperAdminMobile = '9845501060';
  static const defaultSuperAdminPassword = '5555';
  static const defaultSuperAdminName = 'Ananth';

  static bool isDefaultSuperAdmin(String? userId) =>
      userId == defaultSuperAdminId;

  Future<void> init() async {
    await HiveService.instance.openBox(HiveBoxNames.users);
    await _seedDefaultSuperAdmin();
    await _migrateUsers();
  }

  Future<void> _seedDefaultSuperAdmin() async {
    final hive = HiveService.instance;
    final existing = hive.get(HiveBoxNames.users, defaultSuperAdminId);

    if (existing != null) {
      final record = Map<String, dynamic>.from(existing);
      const migrationKey = 'default_super_admin_migrated';
      final alreadyMigrated =
          hive.get(HiveBoxNames.settings, migrationKey)?['done'] == true;

      if (alreadyMigrated) {
        return;
      }

      var changed = false;

      if (record['password']?.toString() == '55555') {
        record['password'] = defaultSuperAdminPassword;
        changed = true;
      }
      if (record['name']?.toString() == 'Role-Admin') {
        record['name'] = defaultSuperAdminName;
        changed = true;
      }
      if (record['mobile']?.toString() != defaultSuperAdminMobile) {
        record['mobile'] = defaultSuperAdminMobile;
        changed = true;
      }
      if (record['role']?.toString() != AppRole.superAdmin) {
        record['role'] = AppRole.superAdmin;
        changed = true;
      }
      if (record['status']?.toString() != UserStatus.active) {
        record['status'] = UserStatus.active;
        changed = true;
      }

      if (changed) {
        record['updatedAt'] = DateTime.now().toIso8601String();
        await hive.put(HiveBoxNames.users, defaultSuperAdminId, record);
      }

      await hive.put(HiveBoxNames.settings, migrationKey, {'done': true});
      return;
    }

    await hive.put(HiveBoxNames.users, defaultSuperAdminId, {
      'id': defaultSuperAdminId,
      'name': defaultSuperAdminName,
      'mobile': defaultSuperAdminMobile,
      'password': defaultSuperAdminPassword,
      'role': AppRole.superAdmin,
      'status': UserStatus.active,
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    });
  }

  Future<void> _migrateUsers() async {
    const migrationKey = 'users_status_migrated';
    final hive = HiveService.instance;
    if (hive.get(HiveBoxNames.settings, migrationKey)?['done'] == true) {
      return;
    }

    for (final user in getAllUsers()) {
      if (user['status'] == null) {
        final id = user['id']?.toString();
        if (id == null) continue;
        await hive.put(HiveBoxNames.users, id, {
          ...user,
          'status': UserStatus.active,
        });
      }
    }

    await hive.put(HiveBoxNames.settings, migrationKey, {'done': true});
  }

  List<Map<String, dynamic>> getAllUsers() {
    return HiveService.instance.getAll(HiveBoxNames.users);
  }

  Map<String, dynamic>? findByMobile(String mobile) {
    for (final user in getAllUsers()) {
      if (user['mobile']?.toString() == mobile) {
        return user;
      }
    }
    return null;
  }

  Future<void> saveUser(Map<String, dynamic> user) async {
    final userId = user['id']?.toString();
    if (isDefaultSuperAdmin(userId)) {
      user['role'] = AppRole.superAdmin;
      user['status'] = UserStatus.active;
    }

    await HiveService.instance.put(
      HiveBoxNames.users,
      userId!,
      user,
    );
  }

  Future<void> deleteUser(String id) async {
    await HiveService.instance.delete(HiveBoxNames.users, id);
  }
}
