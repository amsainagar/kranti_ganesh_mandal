import 'package:flutter_test/flutter_test.dart';
import 'package:kranti_ganesh_mandal/models/app_role.dart';

void main() {
  test('role permission helpers', () {
    expect(AppRole.canEditContent(AppRole.superAdmin), isTrue);
    expect(AppRole.canEditContent(AppRole.admin), isTrue);
    expect(AppRole.canEditContent(AppRole.member), isFalse);
    expect(AppRole.canEditContent(AppRole.user), isFalse);

    expect(AppRole.canManageUsers(AppRole.superAdmin), isTrue);
    expect(AppRole.canManageUsers(AppRole.member), isFalse);

    expect(AppRole.canViewGallery(AppRole.member), isTrue);
    expect(AppRole.canViewGallery(AppRole.user), isFalse);
  });

  test('role lists contain expected values', () {
    expect(AppRole.assignable, [AppRole.admin, AppRole.member, AppRole.user]);
    expect(AppRole.all, contains(AppRole.superAdmin));
  });
}
