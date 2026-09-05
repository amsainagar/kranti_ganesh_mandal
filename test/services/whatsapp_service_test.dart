import 'package:flutter_test/flutter_test.dart';
import 'package:kranti_ganesh_mandal/services/whatsapp_service.dart';

void main() {
  final service = WhatsAppService.instance;

  test('toWhatsAppNumber prefixes India country code', () {
    expect(WhatsAppService.toWhatsAppNumber('9845501060'), '919845501060');
    expect(WhatsAppService.toWhatsAppNumber('919845501060'), '919845501060');
  });

  test('registrationUri builds wa.me link with encoded message', () {
    final uri = service.registrationUri(
      mobile: '9845501060',
      message: 'Hello Ananth',
    );

    expect(uri.scheme, 'https');
    expect(uri.host, 'wa.me');
    expect(uri.path, '/919845501060');
    expect(uri.queryParameters['text'], 'Hello Ananth');
  });
}
