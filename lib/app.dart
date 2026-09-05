import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:kranti_ganesh_mandal/core/auth/auth_controller.dart';
import 'package:kranti_ganesh_mandal/core/constants/app_constants.dart';
import 'package:kranti_ganesh_mandal/core/locale/locale_controller.dart';
import 'package:kranti_ganesh_mandal/core/router/app_router.dart';
import 'package:kranti_ganesh_mandal/core/theme/app_theme.dart';
import 'package:kranti_ganesh_mandal/l10n/app_localizations.dart';

class KrantiGaneshMandalApp extends StatefulWidget {
  const KrantiGaneshMandalApp({super.key});

  @override
  State<KrantiGaneshMandalApp> createState() => _KrantiGaneshMandalAppState();
}

class _KrantiGaneshMandalAppState extends State<KrantiGaneshMandalApp> {
  late final AppRouter _appRouter;

  @override
  void initState() {
    super.initState();
    _appRouter = AppRouter(AuthController.instance);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FlutterNativeSplash.remove();
    });
  }

  @override
  Widget build(BuildContext context) {
    final localeController = LocaleController.instance;
    final authController = AuthController.instance;

    return ListenableBuilder(
      listenable: Listenable.merge([localeController, authController]),
      builder: (context, _) {
        return MaterialApp.router(
          title: AppConstants.appName,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          locale: localeController.locale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: LocaleController.supportedLocales,
          routerConfig: _appRouter.router,
        );
      },
    );
  }
}
