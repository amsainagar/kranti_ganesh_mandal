import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kranti_ganesh_mandal/core/locale/l10n_extensions.dart';
import 'package:kranti_ganesh_mandal/l10n/app_localizations.dart';

void main() {
  testWidgets('formatRecordDateTime uses dd-MM-yyyy and HH-mm-ss', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) {
            final formatted = formatRecordDateTime(context, {
              'updatedAt': '2026-09-05T21:30:45.000',
            });
            expect(formatted, '05-09-2026 · 21-30-45');
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  });

  testWidgets('currencyLocaleFor returns mr_IN for Marathi', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('mr'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) {
            expect(currencyLocaleFor(context), 'mr_IN');
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  });

  testWidgets('currencyLocaleFor returns en_IN for English', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) {
            expect(currencyLocaleFor(context), 'en_IN');
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  });
}
