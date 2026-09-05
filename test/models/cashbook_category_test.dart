import 'package:flutter_test/flutter_test.dart';
import 'package:kranti_ganesh_mandal/models/cashbook_category.dart';

void main() {
  test('income and expense categories are separated', () {
    expect(CashbookCategory.incomeCategories, [CashbookCategory.donation]);
    expect(
      CashbookCategory.expenseCategories,
      isNot(contains(CashbookCategory.donation)),
    );
    expect(CashbookCategory.expenseCategories, contains(CashbookCategory.pooja));
  });
}
