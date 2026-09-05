import 'package:flutter/material.dart';
import 'package:kranti_ganesh_mandal/core/locale/l10n_extensions.dart';
import 'package:kranti_ganesh_mandal/core/locale/locale_controller.dart';

class LanguageToggleButton extends StatelessWidget {
  const LanguageToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isMarathi = Localizations.localeOf(context).languageCode == 'mr';

    return IconButton(
      tooltip: l10n.language,
      onPressed: LocaleController.instance.toggleLocale,
      icon: Text(
        isMarathi ? 'EN' : 'म',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }
}
