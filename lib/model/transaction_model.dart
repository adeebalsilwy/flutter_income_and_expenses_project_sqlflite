class Transaction_model {
  final int? id;
  final int? categoryId;
  final double amount;
  final String date;
  final String type;

  Transaction_model({
    this.id,
    required this.categoryId,
    required this.amount,
    required this.date,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'categoryId': categoryId,
      'amount': amount,
      'date': date,
      'type': type,
    };
  }

  factory Transaction_model.fromMap(Map<String, dynamic> map) {
    return Transaction_model(
      id: map['id'],
      categoryId: map['categoryId'],
      amount: map['amount'],
      date: map['date'],
      type: map['type'],
    );
  }
}
