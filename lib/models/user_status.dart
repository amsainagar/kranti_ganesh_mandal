abstract final class UserStatus {
  static const active = 'active';
  static const inactive = 'inactive';

  static bool isActive(Map<String, dynamic> user) {
    final status = user['status']?.toString();
    if (status == null || status.isEmpty) return true;
    return status == active;
  }
}
