class Report {
  final int? id;
  final String month;
  final double totalIncome;
  final double totalExpense;

  Report({
    this.id,
    required this.month,
    required this.totalIncome,
    required this.totalExpense,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'month': month,
      'totalIncome': totalIncome,
      'totalExpense': totalExpense,
    };
  }

  factory Report.fromMap(Map<String, dynamic> map) {
    return Report(
      id: map['id'],
      month: map['month'],
      totalIncome: map['totalIncome'],
      totalExpense: map['totalExpense'],
    );
  }
}
