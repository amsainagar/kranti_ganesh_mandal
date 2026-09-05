import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kranti_ganesh_mandal/core/auth/auth_controller.dart';
import 'package:kranti_ganesh_mandal/core/constants/app_colors.dart';
import 'package:kranti_ganesh_mandal/core/locale/l10n_extensions.dart';
import 'package:kranti_ganesh_mandal/core/router/app_router.dart';
import 'package:kranti_ganesh_mandal/core/widgets/app_widgets.dart';
import 'package:kranti_ganesh_mandal/core/widgets/language_toggle_button.dart';
import 'package:kranti_ganesh_mandal/l10n/app_localizations.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final auth = AuthController.instance;
    final modules = _modulesFor(l10n, auth);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 100,
            pinned: true,
            actions: [
              const LanguageToggleButton(),
              PopupMenuButton<String>(
                icon: const Icon(Icons.account_circle),
                onSelected: (value) async {
                  if (value == 'logout') {
                    await auth.logout();
                    if (context.mounted) {
                      context.go(AppRoutes.splash);
                    }
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    enabled: false,
                    child: Text(
                      auth.displayName.isNotEmpty
                          ? auth.displayName
                          : auth.mobile,
                    ),
                  ),
                  PopupMenuItem(
                    value: 'logout',
                    child: Text(l10n.logout),
                  ),
                ],
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.primary, AppColors.secondary],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.temple_hindu_rounded,
                          color: Colors.white,
                          size: 32,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.appName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  height: 1.2,
                                ),
                              ),
                              Text(
                                l10n.appSubtitle,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                  height: 1.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                childAspectRatio: 0.88,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final module = modules[index];
                  return ModuleCard(
                    title: module.title,
                    subtitle: module.subtitle,
                    icon: module.icon,
                    color: module.color,
                    onTap: () => context.push(module.route),
                  );
                },
                childCount: modules.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static List<_ModuleInfo> _modulesFor(
    AppLocalizations l10n,
    AuthController auth,
  ) {
    final modules = <_ModuleInfo>[
      _ModuleInfo(
        title: l10n.pledgeLedger,
        subtitle: l10n.pledgeLedgerSubtitle,
        icon: Icons.menu_book_rounded,
        color: AppColors.primary,
        route: AppRoutes.pledgeLedger,
      ),
      _ModuleInfo(
        title: l10n.cashbook,
        subtitle: l10n.cashbookSubtitle,
        icon: Icons.account_balance_wallet_rounded,
        color: AppColors.secondary,
        route: AppRoutes.cashbook,
      ),
      _ModuleInfo(
        title: l10n.games,
        subtitle: l10n.gamesSubtitle,
        icon: Icons.sports_esports_rounded,
        color: AppColors.success,
        route: AppRoutes.games,
      ),
      _ModuleInfo(
        title: l10n.mankari,
        subtitle: l10n.mankariSubtitle,
        icon: Icons.groups_rounded,
        color: AppColors.pending,
        route: AppRoutes.mankari,
      ),
    ];

    if (auth.canViewGallery) {
      modules.add(
        _ModuleInfo(
          title: l10n.gallery,
          subtitle: l10n.gallerySubtitle,
          icon: Icons.photo_library_rounded,
          color: AppColors.primary,
          route: AppRoutes.gallery,
        ),
      );
    }

    modules.add(
      _ModuleInfo(
        title: l10n.reports,
        subtitle: l10n.reportsSubtitle,
        icon: Icons.assessment_rounded,
        color: AppColors.secondary,
        route: AppRoutes.reports,
      ),
    );

    if (auth.canManageUsers) {
      modules.add(
        _ModuleInfo(
          title: l10n.admin,
          subtitle: l10n.adminSubtitle,
          icon: Icons.admin_panel_settings_rounded,
          color: AppColors.primary,
          route: AppRoutes.admin,
        ),
      );
    }

    return modules;
  }
}

class _ModuleInfo {
  const _ModuleInfo({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.route,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final String route;
}
