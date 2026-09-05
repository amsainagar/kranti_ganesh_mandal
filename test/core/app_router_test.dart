import 'package:flutter_test/flutter_test.dart';
import 'package:kranti_ganesh_mandal/core/router/app_router.dart';

void main() {
  test('guest users stay on splash and cannot open modules', () {
    expect(
      resolveAppRedirect(
        isLoggedIn: false,
        location: AppRoutes.splash,
        canViewGallery: false,
        canManageUsers: false,
      ),
      isNull,
    );
    expect(
      resolveAppRedirect(
        isLoggedIn: false,
        location: AppRoutes.home,
        canViewGallery: false,
        canManageUsers: false,
      ),
      AppRoutes.splash,
    );
    expect(
      resolveAppRedirect(
        isLoggedIn: false,
        location: AppRoutes.cashbook,
        canViewGallery: false,
        canManageUsers: false,
      ),
      AppRoutes.splash,
    );
  });

  test('logged in users skip splash', () {
    expect(
      resolveAppRedirect(
        isLoggedIn: true,
        location: AppRoutes.splash,
        canViewGallery: true,
        canManageUsers: true,
      ),
      AppRoutes.home,
    );
    expect(
      resolveAppRedirect(
        isLoggedIn: true,
        location: AppRoutes.home,
        canViewGallery: true,
        canManageUsers: true,
      ),
      isNull,
    );
  });

  test('gallery and admin routes respect role permissions', () {
    expect(
      resolveAppRedirect(
        isLoggedIn: true,
        location: AppRoutes.gallery,
        canViewGallery: false,
        canManageUsers: false,
      ),
      AppRoutes.home,
    );
    expect(
      resolveAppRedirect(
        isLoggedIn: true,
        location: AppRoutes.admin,
        canViewGallery: true,
        canManageUsers: false,
      ),
      AppRoutes.home,
    );
    expect(
      resolveAppRedirect(
        isLoggedIn: true,
        location: AppRoutes.gallery,
        canViewGallery: true,
        canManageUsers: false,
      ),
      isNull,
    );
    expect(
      resolveAppRedirect(
        isLoggedIn: true,
        location: AppRoutes.admin,
        canViewGallery: false,
        canManageUsers: true,
      ),
      isNull,
    );
  });
}
