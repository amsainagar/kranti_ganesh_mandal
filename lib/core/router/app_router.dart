import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kranti_ganesh_mandal/core/auth/auth_controller.dart';
import 'package:kranti_ganesh_mandal/core/router/page_transitions.dart';
import 'package:kranti_ganesh_mandal/pages/admin/admin_page.dart';
import 'package:kranti_ganesh_mandal/pages/cashbook/cashbook_page.dart';
import 'package:kranti_ganesh_mandal/pages/gallery/gallery_page.dart';
import 'package:kranti_ganesh_mandal/pages/games/games_page.dart';
import 'package:kranti_ganesh_mandal/pages/home/home_page.dart';
import 'package:kranti_ganesh_mandal/pages/mankari/mankari_page.dart';
import 'package:kranti_ganesh_mandal/pages/pledge_ledger/pledge_ledger_page.dart';
import 'package:kranti_ganesh_mandal/pages/reports/reports_page.dart';
import 'package:kranti_ganesh_mandal/pages/splash/splash_page.dart';

abstract final class AppRoutes {
  static const splash = '/';
  static const home = '/home';
  static const pledgeLedger = '/home/pledge-ledger';
  static const cashbook = '/home/cashbook';
  static const games = '/home/games';
  static const mankari = '/home/mankari';
  static const gallery = '/home/gallery';
  static const reports = '/home/reports';
  static const admin = '/home/admin';
}

String? resolveAppRedirect({
  required bool isLoggedIn,
  required String location,
  required bool canViewGallery,
  required bool canManageUsers,
}) {
  final onSplash = location == AppRoutes.splash;

  if (!isLoggedIn && !onSplash) {
    return AppRoutes.splash;
  }
  if (isLoggedIn && onSplash) {
    return AppRoutes.home;
  }
  if (location == AppRoutes.gallery && !canViewGallery) {
    return AppRoutes.home;
  }
  if (location == AppRoutes.admin && !canManageUsers) {
    return AppRoutes.home;
  }
  return null;
}

final class AppRouter {
  AppRouter(this._auth);

  final AuthController _auth;

  late final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: _auth,
    redirect: _redirect,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        pageBuilder: (context, state) =>
            PageTransitions.fade(state, const SplashPage()),
      ),
      GoRoute(
        path: AppRoutes.home,
        pageBuilder: (context, state) =>
            PageTransitions.fade(state, const HomePage()),
        routes: [
          GoRoute(
            path: 'pledge-ledger',
            pageBuilder: (context, state) =>
                PageTransitions.slide(state, const PledgeLedgerPage()),
          ),
          GoRoute(
            path: 'cashbook',
            pageBuilder: (context, state) =>
                PageTransitions.slide(state, const CashbookPage()),
          ),
          GoRoute(
            path: 'games',
            pageBuilder: (context, state) =>
                PageTransitions.slide(state, const GamesPage()),
          ),
          GoRoute(
            path: 'mankari',
            pageBuilder: (context, state) =>
                PageTransitions.slide(state, const MankariPage()),
          ),
          GoRoute(
            path: 'gallery',
            pageBuilder: (context, state) =>
                PageTransitions.slide(state, const GalleryPage()),
          ),
          GoRoute(
            path: 'reports',
            pageBuilder: (context, state) =>
                PageTransitions.slide(state, const ReportsPage()),
          ),
          GoRoute(
            path: 'admin',
            pageBuilder: (context, state) =>
                PageTransitions.slide(state, const AdminPage()),
          ),
        ],
      ),
    ],
  );

  String? _redirect(BuildContext context, GoRouterState state) {
    return resolveAppRedirect(
      isLoggedIn: _auth.isLoggedIn,
      location: state.matchedLocation,
      canViewGallery: _auth.canViewGallery,
      canManageUsers: _auth.canManageUsers,
    );
  }
}
