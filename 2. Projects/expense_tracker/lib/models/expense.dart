import 'package:cloud_firestore/cloud_firestore.dart';

class Expense {
  final String id;
  final double amount;
  final String category;
  final String description;
  final DateTime date;
  final String? receiptUrl;

  const Expense({
    required this.id,
    required this.amount,
    required this.category,
    required this.description,
    required this.date,
    this.receiptUrl,
  });

  factory Expense.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    
    DateTime parsedDate;
    final dateVal = data['date'];
    if (dateVal is Timestamp) {
      parsedDate = dateVal.toDate();
    } else if (dateVal is String) {
      parsedDate = DateTime.tryParse(dateVal) ?? DateTime.now();
    } else {
      parsedDate = DateTime.now();
    }

    final amountVal = data['amount'];
    double parsedAmount = 0.0;
    if (amountVal is num) {
      parsedAmount = amountVal.toDouble();
    } else if (amountVal is String) {
      parsedAmount = double.tryParse(amountVal) ?? 0.0;
    }

    return Expense(
      id: doc.id,
      amount: parsedAmount,
      category: (data['category'] as String?)?.trim() ?? 'General',
      description: (data['description'] as String?)?.trim() ?? '',
      date: parsedDate,
      receiptUrl: (data['receiptUrl'] as String?)?.trim(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'amount': amount,
      'category': category,
      'description': description,
      'date': Timestamp.fromDate(date),
      'receiptUrl': receiptUrl,
    };
  }

  Expense copyWith({
    String? id,
    double? amount,
    String? category,
    String? description,
    DateTime? date,
    String? receiptUrl,
  }) {
    return Expense(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      description: description ?? this.description,
      date: date ?? this.date,
      receiptUrl: receiptUrl ?? this.receiptUrl,
    );
  }
}

