abstract final class AppRole {
  static const superAdmin = 'super_admin';
  static const admin = 'admin';
  static const member = 'member';
  static const user = 'user';

  static const assignable = [admin, member, user];
  static const all = [superAdmin, admin, member, user];

  static bool canEditContent(String role) =>
      role == superAdmin || role == admin;

  static bool canManageUsers(String role) =>
      role == superAdmin || role == admin;

  static bool canViewGallery(String role) =>
      role == superAdmin || role == admin || role == member;
}
