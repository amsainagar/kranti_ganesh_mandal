final class ReportsService {
  ReportsService._();

  static double pledgeTotal(List<Map<String, dynamic>> pledges) {
    return pledges.fold<double>(
      0,
      (sum, pledge) => sum + _amount(pledge['amount']),
    );
  }

  static double pledgeCollected(List<Map<String, dynamic>> pledges) {
    return pledges
        .where((pledge) => pledge['isCompleted'] == true)
        .fold<double>(0, (sum, pledge) => sum + _amount(pledge['amount']));
  }

  static double pledgePending(List<Map<String, dynamic>> pledges) {
    return pledges
        .where((pledge) => pledge['isCompleted'] != true)
        .fold<double>(0, (sum, pledge) => sum + _amount(pledge['amount']));
  }

  static double cashbookIncome(List<Map<String, dynamic>> entries) {
    return entries
        .where((entry) => entry['isIncome'] == true)
        .fold<double>(0, (sum, entry) => sum + _amount(entry['amount']));
  }

  static double cashbookExpense(List<Map<String, dynamic>> entries) {
    return entries
        .where((entry) => entry['isIncome'] != true)
        .fold<double>(0, (sum, entry) => sum + _amount(entry['amount']));
  }

  static double cashbookBalance(List<Map<String, dynamic>> entries) {
    return cashbookIncome(entries) - cashbookExpense(entries);
  }

  static int mankariShiftCount(List<Map<String, dynamic>> volunteers) {
    return volunteers.length;
  }

  static double _amount(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }
}
