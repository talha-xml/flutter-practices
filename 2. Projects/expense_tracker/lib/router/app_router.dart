import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../models/expense.dart';
import '../screens/add_edit_expense_screen.dart';
import '../screens/auth_screen.dart';
import '../screens/currency_converter_screen.dart';
import '../screens/expense_detail_screen.dart';
import '../screens/expenses_screen.dart';

// Listenable notifier for GoRouter refresh on auth changes
class AuthNotifier extends ChangeNotifier {
  AuthNotifier() {
    FirebaseAuth.instance.authStateChanges().listen((_) {
      notifyListeners();
    });
  }
}

final authNotifierProvider = Provider<AuthNotifier>((ref) {
  return AuthNotifier();
});

final routerProvider = Provider<GoRouter>((ref) {
  final authNotifier = ref.watch(authNotifierProvider);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: authNotifier,
    redirect: (context, state) {
      final user = FirebaseAuth.instance.currentUser;
      final isLoggingIn = state.matchedLocation == '/auth';

      if (user == null) {
        return isLoggingIn ? null : '/auth';
      }

      if (isLoggingIn) {
        return '/';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/auth',
        builder: (context, state) => const AuthScreen(),
      ),
      GoRoute(
        path: '/',
        builder: (context, state) => const ExpensesScreen(),
        routes: [
          GoRoute(
            path: 'add',
            builder: (context, state) => const AddEditExpenseScreen(),
          ),
          GoRoute(
            path: 'edit/:id',
            builder: (context, state) {
              final id = state.pathParameters['id'];
              final expense = state.extra as Expense?;
              return AddEditExpenseScreen(
                expenseId: id,
                initialExpense: expense,
              );
            },
          ),
          GoRoute(
            path: 'detail/:id',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return ExpenseDetailScreen(expenseId: id);
            },
          ),
          GoRoute(
            path: 'converter',
            builder: (context, state) => const CurrencyConverterScreen(),
          ),
        ],
      ),
    ],
  );
});
