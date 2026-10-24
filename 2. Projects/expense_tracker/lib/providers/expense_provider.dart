import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/expense.dart';
import '../services/cloudinary_service.dart';
import '../services/currency_service.dart';

final cloudinaryServiceProvider = Provider<CloudinaryService>((ref) {
  return CloudinaryService();
});

final currencyServiceProvider = Provider<CurrencyService>((ref) {
  return CurrencyService();
});

final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

class ExpenseRepository {
  final FirebaseFirestore _firestore;

  ExpenseRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _userExpensesRef(String uid) {
    return _firestore.collection('users').doc(uid).collection('expenses');
  }

  Stream<List<Expense>> watchExpenses(String uid) {
    return _userExpensesRef(uid)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Expense.fromFirestore(doc)).toList();
    });
  }

  Stream<Expense?> watchExpense(String uid, String expenseId) {
    return _userExpensesRef(uid).doc(expenseId).snapshots().map((doc) {
      if (!doc.exists) return null;
      return Expense.fromFirestore(doc);
    });
  }

  Future<Expense?> getExpense(String uid, String expenseId) async {
    final doc = await _userExpensesRef(uid).doc(expenseId).get();
    if (!doc.exists) return null;
    return Expense.fromFirestore(doc);
  }

  Future<void> addExpense(String uid, Expense expense) async {
    await _userExpensesRef(uid).add(expense.toFirestore());
  }

  Future<void> updateExpense(String uid, Expense expense) async {
    await _userExpensesRef(uid).doc(expense.id).set(
          expense.toFirestore(),
          SetOptions(merge: true),
        );
  }

  Future<void> deleteExpense(String uid, String expenseId) async {
    await _userExpensesRef(uid).doc(expenseId).delete();
  }
}

final expenseRepositoryProvider = Provider<ExpenseRepository>((ref) {
  return ExpenseRepository();
});

final expensesListProvider = StreamProvider<List<Expense>>((ref) {
  final authUser = ref.watch(authStateProvider).value;
  if (authUser == null) {
    return Stream.value([]);
  }
  final repo = ref.watch(expenseRepositoryProvider);
  return repo.watchExpenses(authUser.uid);
});

final singleExpenseProvider =
    StreamProvider.family<Expense?, String>((ref, expenseId) {
  final authUser = ref.watch(authStateProvider).value;
  if (authUser == null) return Stream.value(null);
  final repo = ref.watch(expenseRepositoryProvider);
  return repo.watchExpense(authUser.uid, expenseId);
});
