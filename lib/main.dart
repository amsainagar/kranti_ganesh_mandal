import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:kranti_ganesh_mandal/core/auth/auth_controller.dart';
import 'package:kranti_ganesh_mandal/app.dart';
import 'package:kranti_ganesh_mandal/core/locale/locale_controller.dart';
import 'package:kranti_ganesh_mandal/services/hive_service.dart';

Future<void> main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await HiveService.instance.init();
  await Future.wait([
    LocaleController.instance.init(),
    AuthController.instance.init(),
  ]);

  runApp(const KrantiGaneshMandalApp());
}
