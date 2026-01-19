class TransactionModel {
  final String id;
  final String title;
  final double amount;
  final bool isIncome;
  final DateTime date;

  TransactionModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.isIncome,
    required this.date,
  });

  // Converte JSON do Realtime DB para o Objeto
  factory TransactionModel.fromMap(String id, Map<dynamic, dynamic> map) {
    return TransactionModel(
      id: id,
      title: map['title'] ?? '',
      amount: (map['amount'] ?? 0).toDouble(),
      isIncome: map['isIncome'] ?? false,
      date: DateTime.parse(map['date']), // ISO 8601 String
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'amount': amount,
      'isIncome': isIncome,
      'date': date.toIso8601String(),
    };
  }
}