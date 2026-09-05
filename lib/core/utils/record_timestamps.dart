abstract final class RecordTimestamps {
  static DateTime? parse(dynamic value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }

  static DateTime sortKey(Map<String, dynamic> record) {
    return parse(record['updatedAt']) ??
        parse(record['createdAt']) ??
        DateTime.fromMillisecondsSinceEpoch(0);
  }

  static List<Map<String, dynamic>> sortLatest(
    List<Map<String, dynamic>> items,
  ) {
    final sorted = items.map((item) => Map<String, dynamic>.from(item)).toList();
    sorted.sort((a, b) => sortKey(b).compareTo(sortKey(a)));
    return sorted;
  }

  static Map<String, dynamic> stamp(
    Map<String, dynamic> record, {
    Map<String, dynamic>? existing,
  }) {
    final now = DateTime.now().toIso8601String();
    return {
      ...record,
      'updatedAt': now,
      'createdAt': existing?['createdAt']?.toString() ?? now,
    };
  }
}
