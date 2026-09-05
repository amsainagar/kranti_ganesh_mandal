import 'package:flutter_test/flutter_test.dart';
import 'package:kranti_ganesh_mandal/core/utils/record_timestamps.dart';

void main() {
  test('parse handles null and invalid values', () {
    expect(RecordTimestamps.parse(null), isNull);
    expect(RecordTimestamps.parse('not-a-date'), isNull);
    expect(
      RecordTimestamps.parse('2026-08-18T09:00:00.000'),
      DateTime(2026, 8, 18, 9),
    );
  });

  test('sortKey prefers updatedAt over createdAt', () {
    final record = {
      'createdAt': '2026-01-01T00:00:00.000',
      'updatedAt': '2026-02-01T00:00:00.000',
    };
    expect(RecordTimestamps.sortKey(record), DateTime(2026, 2, 1));
  });

  test('sortLatest orders newest first without mutating source', () {
    final items = [
      {'id': '1', 'updatedAt': '2026-01-01T00:00:00.000'},
      {'id': '2', 'updatedAt': '2026-03-01T00:00:00.000'},
    ];

    final sorted = RecordTimestamps.sortLatest(items);

    expect(sorted.first['id'], '2');
    expect(items.first['id'], '1');
  });

  test('stamp uses now when no existing createdAt', () {
    final stamped = RecordTimestamps.stamp({'id': '1'});
    expect(stamped['createdAt'], stamped['updatedAt']);
  });

  test('sortKey falls back to epoch when timestamps missing', () {
    expect(
      RecordTimestamps.sortKey({}),
      DateTime.fromMillisecondsSinceEpoch(0),
    );
  });

  test('stamp preserves createdAt and sets updatedAt', () {
    final existing = {
      'id': '1',
      'createdAt': '2026-01-01T00:00:00.000',
    };

    final stamped = RecordTimestamps.stamp(
      {'id': '1', 'name': 'Test'},
      existing: existing,
    );

    expect(stamped['createdAt'], '2026-01-01T00:00:00.000');
    expect(stamped['updatedAt'], isNotNull);
    expect(stamped['name'], 'Test');
  });
}
