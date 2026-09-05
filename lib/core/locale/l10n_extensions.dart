import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kranti_ganesh_mandal/core/utils/record_timestamps.dart';
import 'package:kranti_ganesh_mandal/l10n/app_localizations.dart';

extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

String currencyLocaleFor(BuildContext context) {
  final code = Localizations.localeOf(context).languageCode;
  return code == 'mr' ? 'mr_IN' : 'en_IN';
}

String formatRecordDateTime(BuildContext context, Map<String, dynamic> record) {
  final dateTime = RecordTimestamps.sortKey(record);
  final date = DateFormat('dd-MM-yyyy').format(dateTime);
  final time = DateFormat('HH-mm-ss').format(dateTime);
  return '$date · $time';
}
