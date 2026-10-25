import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

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
    try {
      if (source == ImageSource.camera) {
        var status = await Permission.camera.status;
        if (!status.isGranted) {
          status = await Permission.camera.request();
        }

        if (!mounted) return;
        if (!status.isGranted) {
          if (status.isPermanentlyDenied) {
            await _showPermissionSettingsDialog();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Camera permission denied. You can choose a photo from the gallery.',
                ),
              ),
            );
          }
          return;
        }
      }

      final picker = ImagePicker();
      final file = await picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 75,
      );
      if (!mounted || file == null) return;

      setState(() => _selectedImage = file);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not select the photo. Try again.')),
        );
      }
    }
  }

  Future<void> _showPermissionSettingsDialog() async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Camera permission required'),
        content: const Text(
          'Allow camera access in app settings, or choose a photo from the gallery.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  Future<void> _save() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in first.')),
      );
      return;
    }

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
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _amountController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  textInputAction: TextInputAction.next,
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
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(labelText: 'Category'),
                  validator: (val) =>
                      val == null || val.trim().isEmpty ? 'Enter category' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _descriptionController,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _save(),
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
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
            ),
            onPressed: _isLoading ? null : _save,
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(
                    isEditing ? 'Update Expense' : 'Save Expense',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
          ),
        ),
      ),
    );
  }
}
