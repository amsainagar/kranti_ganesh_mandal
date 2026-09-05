import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:kranti_ganesh_mandal/services/hive_service.dart';
import '../helpers/hive_test_helper.dart';

void main() {
  late Directory tempDir;
  final hive = HiveService.instance;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    tempDir = await setUpHiveTests();
  });

  tearDownAll(() async {
    await tearDownHiveTests(tempDir);
  });

  test('put get delete and getAll work', () async {
    await hive.openBox(HiveBoxNames.cashbook);
    await hive.put(HiveBoxNames.cashbook, 'entry-1', {
      'id': 'entry-1',
      'amount': 100,
    });

    expect(hive.get(HiveBoxNames.cashbook, 'entry-1')?['amount'], 100);

    final all = hive.getAll(HiveBoxNames.cashbook);
    expect(all.any((entry) => entry['id'] == 'entry-1'), isTrue);

    await hive.delete(HiveBoxNames.cashbook, 'entry-1');
    expect(hive.get(HiveBoxNames.cashbook, 'entry-1'), isNull);
  });

  test('clear removes all records in box', () async {
    await hive.openBox(HiveBoxNames.games);
    await hive.put(HiveBoxNames.games, 'g1', {'id': 'g1'});
    await hive.put(HiveBoxNames.games, 'g2', {'id': 'g2'});

    await hive.clear(HiveBoxNames.games);

    expect(hive.getAll(HiveBoxNames.games), isEmpty);
  });

  test('openBox is idempotent', () async {
    await hive.openBox(HiveBoxNames.mankari);
    await hive.openBox(HiveBoxNames.mankari);
    await hive.put(HiveBoxNames.mankari, 'v1', {'id': 'v1', 'name': 'Volunteer'});
    expect(hive.get(HiveBoxNames.mankari, 'v1')?['name'], 'Volunteer');
  });
}
