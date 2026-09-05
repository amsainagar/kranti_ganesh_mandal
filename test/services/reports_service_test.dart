import 'package:flutter_test/flutter_test.dart';
import 'package:kranti_ganesh_mandal/services/reports_service.dart';

void main() {
  final pledges = [
    {'amount': 1000, 'isCompleted': true},
    {'amount': 500, 'isCompleted': false},
    {'amount': '250', 'isCompleted': true},
    {'amount': 'bad', 'isCompleted': false},
  ];

  final cashbook = [
    {'amount': 3000, 'isIncome': true},
    {'amount': 1200, 'isIncome': false},
    {'amount': '500', 'isIncome': true},
  ];

  test('pledge totals', () {
    expect(ReportsService.pledgeTotal(pledges), 1750);
    expect(ReportsService.pledgeCollected(pledges), 1250);
    expect(ReportsService.pledgePending(pledges), 500);
  });

  test('cashbook totals', () {
    expect(ReportsService.cashbookIncome(cashbook), 3500);
    expect(ReportsService.cashbookExpense(cashbook), 1200);
    expect(ReportsService.cashbookBalance(cashbook), 2300);
  });

  test('mankariShiftCount returns volunteer count', () {
    expect(ReportsService.mankariShiftCount([{}, {}, {}]), 3);
  });

  test('amount helper accepts numeric values', () {
    expect(ReportsService.pledgeTotal([{'amount': 100}]), 100);
    expect(ReportsService.pledgeTotal([{'amount': 100.5}]), 100.5);
    expect(ReportsService.pledgeTotal([{'amount': null}]), 0);
  });
}
