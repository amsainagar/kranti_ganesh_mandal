import 'package:flutter/foundation.dart';
import 'package:kranti_ganesh_mandal/models/app_role.dart';
import 'package:kranti_ganesh_mandal/models/user_status.dart';
import 'package:kranti_ganesh_mandal/services/hive_service.dart';
import 'package:kranti_ganesh_mandal/services/user_service.dart';

final class AuthController extends ChangeNotifier {
  AuthController._();
  static final AuthController instance = AuthController._();

  static const _sessionKey = 'auth_session';

  Map<String, dynamic>? _currentUser;

  bool get isLoggedIn => _currentUser != null;

  String get role => _currentUser?['role']?.toString() ?? AppRole.user;

  String get displayName => _currentUser?['name']?.toString() ?? '';

  String get mobile => _currentUser?['mobile']?.toString() ?? '';

  String? get userId => _currentUser?['id']?.toString();

  bool get canEdit => AppRole.canEditContent(role);

  bool get canViewGallery => AppRole.canViewGallery(role);

  bool get canManageUsers => AppRole.canManageUsers(role);

  bool get isSuperAdmin => role == AppRole.superAdmin;

  Future<void> init() async {
    await UserService.instance.init();
    final session = HiveService.instance.get(HiveBoxNames.settings, _sessionKey);
    final userId = session?['userId']?.toString();
    if (userId == null) return;

    final user = HiveService.instance.get(HiveBoxNames.users, userId);
    if (user != null && UserStatus.isActive(user)) {
      _currentUser = user;
      return;
    }

    await HiveService.instance.delete(HiveBoxNames.settings, _sessionKey);
  }

  static bool isValidMobile(String value) {
    final digits = value.replaceAll(RegExp(r'\D'), '');
    return RegExp(r'^\d{10}$').hasMatch(digits);
  }

  static bool isValidPassword(String value) {
    return RegExp(r'^\d{4}$').hasMatch(value);
  }

  static String normalizeMobile(String value) {
    return value.replaceAll(RegExp(r'\D'), '');
  }

  Future<String?> login({
    required String mobileInput,
    required String password,
  }) async {
    final mobile = normalizeMobile(mobileInput);

    if (!isValidMobile(mobile)) {
      return 'invalidMobile';
    }
    if (!isValidPassword(password)) {
      return 'invalidPassword';
    }

    final knownUser = UserService.instance.findByMobile(mobile);
    if (knownUser == null) {
      return 'invalidCredentials';
    }
    if (!UserStatus.isActive(knownUser)) {
      return 'accountInactive';
    }
    if (knownUser['password']?.toString() != password) {
      return 'invalidCredentials';
    }

    await _setSession(knownUser);
    return null;
  }

  Future<void> logout() async {
    _currentUser = null;
    await HiveService.instance.delete(HiveBoxNames.settings, _sessionKey);
    notifyListeners();
  }

  Future<void> _setSession(Map<String, dynamic> user) async {
    _currentUser = Map<String, dynamic>.from(user);
    final userId = user['id']?.toString();
    if (userId != null) {
      await HiveService.instance.put(HiveBoxNames.settings, _sessionKey, {
        'userId': userId,
      });
    }
    notifyListeners();
  }
}
