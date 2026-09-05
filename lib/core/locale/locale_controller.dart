import 'package:flutter/material.dart';
import 'package:kranti_ganesh_mandal/services/hive_service.dart';

final class LocaleController extends ChangeNotifier {
  LocaleController._();
  static final LocaleController instance = LocaleController._();

  static const _settingsKey = 'locale';
  static const supportedLocales = [
    Locale('en'),
    Locale('mr'),
  ];

  Locale? _locale;

  Locale? get locale => _locale;

  Future<void> init() async {
    final stored = HiveService.instance.get(HiveBoxNames.settings, _settingsKey);
    final code = stored?['code'] as String?;
    if (code != null) {
      _locale = Locale(code);
    }
  }

  Future<void> setLocale(Locale locale) async {
    _locale = locale;
    await HiveService.instance.put(HiveBoxNames.settings, _settingsKey, {
      'code': locale.languageCode,
    });
    notifyListeners();
  }

  Future<void> toggleLocale() async {
    final current = _locale?.languageCode ?? 'en';
    await setLocale(Locale(current == 'en' ? 'mr' : 'en'));
  }
}
