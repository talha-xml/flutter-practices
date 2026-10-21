import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/expense_provider.dart';

class ExpenseDetailScreen extends ConsumerWidget {
  final String expenseId;

  const ExpenseDetailScreen({super.key, required this.expenseId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).value;
    final expenseAsync = ref.watch(singleExpenseProvider(expenseId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Detail'),
        actions: [
          if (expenseAsync.value != null && user != null) ...[
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => context.push(
                '/edit/$expenseId',
                extra: expenseAsync.value,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                await ref
                    .read(expenseRepositoryProvider)
                    .deleteExpense(user.uid, expenseId);
                if (context.mounted) context.pop();
              },
            ),
          ],
        ],
      ),
      body: expenseAsync.when(
        data: (expense) {
          if (expense == null) {
            return const Center(child: Text('Expense not found.'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PKR ${expense.amount.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text('Category: ${expense.category}', style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 4),
                Text('Date: ${expense.date.toLocal().toString().split('.')[0]}'),
                if (expense.description.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text('Description: ${expense.description}'),
                ],
                const Divider(height: 32),
                const Text('Receipt Image:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                if (expense.receiptUrl != null && expense.receiptUrl!.isNotEmpty)
                  Image.network(
                    expense.receiptUrl!,
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) =>
                        const Text('Could not load receipt image.'),
                  )
                else
                  const Text('No receipt attached.'),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
