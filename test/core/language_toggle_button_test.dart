import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kranti_ganesh_mandal/core/widgets/language_toggle_button.dart';
import 'package:kranti_ganesh_mandal/l10n/app_localizations.dart';

void main() {
  testWidgets('shows Marathi toggle label in English locale', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Scaffold(
          body: LanguageToggleButton(),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('म'), findsOneWidget);
  });
}
