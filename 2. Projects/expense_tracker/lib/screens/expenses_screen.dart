import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../notifications/notification_service.dart';
import '../providers/expense_provider.dart';

class ExpensesScreen extends ConsumerStatefulWidget {
  const ExpensesScreen({super.key});

  @override
  ConsumerState<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends ConsumerState<ExpensesScreen> {
  bool _hasPromptedBudget = false;

  void _checkAndPromptBudget(double? budget) {
    if (budget == null && !_hasPromptedBudget) {
      _hasPromptedBudget = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _showBudgetDialog(context, null);
        }
      });
    }
  }

  Future<void> _showBudgetDialog(BuildContext context, double? currentBudget) async {
    final controller = TextEditingController(
      text: currentBudget != null && currentBudget > 0
          ? currentBudget.toStringAsFixed(0)
          : '',
    );
    final formKey = GlobalKey<FormState>();

    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(currentBudget == null ? 'Set Total Budget' : 'Update Budget'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Enter the total amount you want to manage your expenses within:'),
              const SizedBox(height: 12),
              TextFormField(
                controller: controller,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Budget Amount (PKR)',
                  hintText: 'e.g. 30000',
                  border: OutlineInputBorder(),
                ),
                validator: (val) {
                  final num = double.tryParse(val ?? '');
                  if (num == null || num <= 0) {
                    return 'Please enter a valid amount';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          if (currentBudget != null)
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                final newBudget = double.parse(controller.text.trim());
                final user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  try {
                    await ref
                        .read(expenseRepositoryProvider)
                        .setBudget(user.uid, newBudget);
                    if (ctx.mounted) Navigator.pop(ctx);
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Could not save budget: $e')),
                      );
                    }
                  }
                }
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final expensesAsync = ref.watch(expensesListProvider);
    final budgetAsync = ref.watch(userBudgetProvider);

    // Auto-prompt budget if not set yet
    budgetAsync.whenData((budget) => _checkAndPromptBudget(budget));

    return Scaffold(
      appBar: AppBar(
        title: const Text('SpendWise'),
        actions: [
          IconButton(
            icon: const Icon(Icons.currency_exchange),
            tooltip: 'Currency Converter',
            onPressed: () => context.push('/converter'),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () => FirebaseAuth.instance.signOut(),
          ),
        ],
      ),
      body: expensesAsync.when(
        data: (expenses) {
          final totalSpent = expenses.fold<double>(0.0, (sum, item) => sum + item.amount);
          final budget = budgetAsync.value;
          final remaining = budget != null ? (budget - totalSpent) : null;

          NotificationService().checkBudget50PercentThreshold(
            budget: budget,
            totalSpent: totalSpent,
          );

          return Column(
            children: [
              // Budget & Remaining Balance Section
              if (budget == null)
                Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: const Text('Set Your Budget'),
                    subtitle: const Text('Enter total amount to manage (e.g. PKR 30,000)'),
                    trailing: ElevatedButton(
                      onPressed: () => _showBudgetDialog(context, null),
                      child: const Text('Set'),
                    ),
                  ),
                )
              else
                Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Total Budget: PKR ${budget.toStringAsFixed(2)}',
                                style: const TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit, size: 18),
                              tooltip: 'Edit Budget',
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              onPressed: () => _showBudgetDialog(context, budget),
                            ),
                          ],
                        ),
                        const Divider(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                'Total Spent (${expenses.length}):',
                                style: TextStyle(color: Colors.grey.shade700),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'PKR ${totalSpent.toStringAsFixed(2)}',
                              style: const TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Expanded(
                              child: Text(
                                'Remaining Balance:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'PKR ${remaining!.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: remaining < 0 ? Colors.red : Colors.green.shade700,
                              ),
                            ),
                          ],
                        ),
                        if (remaining < 0) ...[
                          const SizedBox(height: 6),
                          Text(
                            'Exceeded by PKR ${(totalSpent - budget).toStringAsFixed(2)}',
                            style: const TextStyle(color: Colors.red, fontSize: 12),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

              const Divider(height: 1),

              // Expenses List
              Expanded(
                child: expenses.isEmpty
                    ? const Center(child: Text('No expenses recorded yet.'))
                    : ListView.builder(
                        itemCount: expenses.length,
                        itemBuilder: (context, index) {
                          final expense = expenses[index];

                          return ListTile(
                            title: Text(expense.category),
                            subtitle: expense.description.isNotEmpty
                                ? Text(expense.description)
                                : null,
                            trailing: Text(
                              'PKR ${expense.amount.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            onTap: () => context.push('/detail/${expense.id}'),
                          );
                        },
                      ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error loading expenses: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/add'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
