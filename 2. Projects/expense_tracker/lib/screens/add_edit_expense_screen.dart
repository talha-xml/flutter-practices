import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../models/expense.dart';
import '../providers/expense_provider.dart';

class AddEditExpenseScreen extends ConsumerStatefulWidget {
  final String? expenseId;
  final Expense? initialExpense;

  const AddEditExpenseScreen({super.key, this.expenseId, this.initialExpense});

  @override
  ConsumerState<AddEditExpenseScreen> createState() => _AddEditExpenseScreenState();
}

class _AddEditExpenseScreenState extends ConsumerState<AddEditExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _amountController;
  late final TextEditingController _categoryController;
  late final TextEditingController _descriptionController;

  XFile? _selectedImage;
  String? _existingReceiptUrl;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final expense = widget.initialExpense;
    _amountController = TextEditingController(
      text: expense != null ? expense.amount.toString() : '',
    );
    _categoryController = TextEditingController(
      text: expense?.category ?? 'General',
    );
    _descriptionController = TextEditingController(
      text: expense?.description ?? '',
    );
    if (expense != null) {
      _existingReceiptUrl = expense.receiptUrl;
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _categoryController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: source, imageQuality: 80);
    if (file != null) {
      setState(() => _selectedImage = file);
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final user = ref.read(authStateProvider).value;
    if (user == null) return;

    setState(() => _isLoading = true);
    String? receiptUrl = _existingReceiptUrl;

    try {
      if (_selectedImage != null) {
        final cloudinary = ref.read(cloudinaryServiceProvider);
        receiptUrl = await cloudinary.uploadImage(_selectedImage!);
      }

      final expense = Expense(
        id: widget.expenseId ?? '',
        amount: double.parse(_amountController.text.trim()),
        category: _categoryController.text.trim(),
        description: _descriptionController.text.trim(),
        date: widget.initialExpense?.date ?? DateTime.now(),
        receiptUrl: receiptUrl,
      );

      final repo = ref.read(expenseRepositoryProvider);
      if (widget.expenseId == null) {
        await repo.addExpense(user.uid, expense);
      } else {
        await repo.updateExpense(user.uid, expense);
      }

      if (mounted) context.pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.expenseId != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Edit Expense' : 'Add Expense')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _amountController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(labelText: 'Amount (PKR)'),
                  validator: (val) {
                    final num = double.tryParse(val ?? '');
                    if (num == null || num <= 0) return 'Enter a valid amount';
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _categoryController,
                  decoration: const InputDecoration(labelText: 'Category'),
                  validator: (val) =>
                      val == null || val.trim().isEmpty ? 'Enter category' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                const SizedBox(height: 12),
                const Divider(),
                const Text('Receipt Image', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                if (_selectedImage != null) ...[
                  SizedBox(
                    height: 150,
                    child: kIsWeb
                        ? Image.network(_selectedImage!.path)
                        : Image.file(File(_selectedImage!.path)),
                  ),
                  TextButton(
                    onPressed: () => setState(() => _selectedImage = null),
                    child: const Text('Remove Selected Image'),
                  ),
                ] else if (_existingReceiptUrl != null) ...[
                  Image.network(_existingReceiptUrl!, height: 150),
                  TextButton(
                    onPressed: () => setState(() => _existingReceiptUrl = null),
                    child: const Text('Remove Receipt'),
                  ),
                ],
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _pickImage(ImageSource.camera),
                        child: const Text('Camera'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _pickImage(ImageSource.gallery),
                        child: const Text('Gallery'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                if (_isLoading)
                  const Center(child: CircularProgressIndicator())
                else
                  ElevatedButton(
                    onPressed: _save,
                    child: Text(isEditing ? 'Update' : 'Save'),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
