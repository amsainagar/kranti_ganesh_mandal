import 'package:flutter_test/flutter_test.dart';
import 'package:kranti_ganesh_mandal/models/user_status.dart';

void main() {
  test('isActive treats missing status as active', () {
    expect(UserStatus.isActive({}), isTrue);
    expect(UserStatus.isActive({'status': ''}), isTrue);
    expect(UserStatus.isActive({'status': UserStatus.active}), isTrue);
    expect(UserStatus.isActive({'status': UserStatus.inactive}), isFalse);
  });
}
