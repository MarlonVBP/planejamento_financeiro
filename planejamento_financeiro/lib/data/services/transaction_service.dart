import 'package:firebase_database/firebase_database.dart';
import '../models/transaction_model.dart';

class TransactionService {
  final DatabaseReference _ref = FirebaseDatabase.instance.ref('transactions');

  Future<void> addTransaction(TransactionModel transaction) async {
    await _ref.push().set(transaction.toMap());
  }

  Stream<List<TransactionModel>> getTransactionsStream() {
    return _ref.onValue.map((event) {
      final data = event.snapshot.value;
      if (data == null) return [];

      final Map<dynamic, dynamic> map = data as Map<dynamic, dynamic>;
      final List<TransactionModel> transactions = [];
      
      map.forEach((key, value) {
        transactions.add(TransactionModel.fromMap(key, value));
      });

      // Ordenar por data (mais recente primeiro)
      transactions.sort((a, b) => b.date.compareTo(a.date));
      return transactions;
    });
  }
}