abstract final class CashbookCategory {
  static const donation = 'donation';
  static const decoration = 'decoration';
  static const pooja = 'pooja';
  static const ganeshIdol = 'ganeshIdol';
  static const ganeshAagman = 'ganeshAagman';
  static const ganeshVisarjan = 'ganeshVisarjan';
  static const prasad = 'prasad';
  static const others = 'others';

  static const incomeCategories = [donation];

  static const expenseCategories = [
    decoration,
    pooja,
    ganeshIdol,
    ganeshAagman,
    ganeshVisarjan,
    prasad,
    others,
  ];
}
