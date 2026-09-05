import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

final class WhatsAppService {
  WhatsAppService._();
  static final WhatsAppService instance = WhatsAppService._();

  static const indiaCountryCode = '91';

  static String toWhatsAppNumber(String mobile) {
    final digits = mobile.replaceAll(RegExp(r'\D'), '');
    if (digits.length == 10) {
      return '$indiaCountryCode$digits';
    }
    return digits;
  }

  Uri registrationUri({
    required String mobile,
    required String message,
  }) {
    return Uri.parse(
      'https://wa.me/${toWhatsAppNumber(mobile)}?text=${Uri.encodeComponent(message)}',
    );
  }

  Future<bool> openRegistrationMessage({
    required String mobile,
    required String message,
  }) async {
    final uri = registrationUri(mobile: mobile, message: message);
    return _launch(uri);
  }

  Future<bool> _launch(Uri uri) async {
    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      return launched;
    } on Exception catch (error, stackTrace) {
      debugPrint('WhatsApp launch failed: $error\n$stackTrace');
      return false;
    }
  }
}
