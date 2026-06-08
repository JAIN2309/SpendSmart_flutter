import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../models/expense.dart';
import '../providers/expense_provider.dart';
import '../utils/constants.dart';
import '../utils/formatter.dart';
import '../widgets/category_chip.dart';

class AddExpenseScreen extends StatefulWidget {
  final Expense? existing;

  const AddExpenseScreen({super.key, this.existing});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  bool _isIncome = false;
  final _amountController = TextEditingController();
  final _titleController = TextEditingController();
  final _noteController = TextEditingController();
  String? _selectedCategory;
  DateTime _selectedDate = DateTime.now();
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    if (widget.existing != null) {
      final e = widget.existing!;
      _isIncome = e.isIncome;
      _amountController.text = e.amount.toStringAsFixed(0);
      _titleController.text = e.title;
      _noteController.text = e.note ?? '';
      _selectedCategory = e.category;
      _selectedDate = e.date;
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _titleController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  List<String> get _categories =>
      _isIncome ? kIncomeCategories : kExpenseCategories;

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: Theme.of(context).colorScheme.copyWith(
                primary: AppColors.primary,
              ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  void _save() {
    final amount = double.tryParse(_amountController.text.trim());
    if (amount == null || amount <= 0) {
      _showError('Enter a valid amount');
      return;
    }
    if (_titleController.text.trim().isEmpty) {
      _showError('Enter a title');
      return;
    }
    if (_selectedCategory == null) {
      _showError('Select a category');
      return;
    }

    setState(() => _saving = true);
    HapticFeedback.mediumImpact();

    final provider = context.read<ExpenseProvider>();
    final expense = Expense(
      id: widget.existing?.id ?? const Uuid().v4(),
      title: _titleController.text.trim(),
      amount: amount,
      category: _selectedCategory!,
      date: _selectedDate,
      note: _noteController.text.trim().isEmpty
          ? null
          : _noteController.text.trim(),
      isIncome: _isIncome,
    );

    if (widget.existing != null) {
      provider.deleteExpense(widget.existing!.id);
    }
    provider.addExpense(expense);
    Navigator.of(context).pop();
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(msg, style: GoogleFonts.poppins()),
          backgroundColor: AppColors.expenseRed,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Income / Expense toggle
              Center(
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.cardDark
                        : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _ToggleButton(
                        label: 'Expense',
                        selected: !_isIncome,
                        color: AppColors.expenseRed,
                        onTap: () => setState(() {
                          _isIncome = false;
                          _selectedCategory = null;
                        }),
                      ),
                      _ToggleButton(
                        label: 'Income',
                        selected: _isIncome,
                        color: AppColors.incomeGreen,
                        onTap: () => setState(() {
                          _isIncome = true;
                          _selectedCategory = null;
                        }),
                      ),
                    ],
                  ),
                ),
              ).animate().fadeIn(duration: 300.ms),

              const SizedBox(height: 28),

              // Amount input
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      '₹',
                      style: GoogleFonts.poppins(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: _isIncome
                            ? AppColors.incomeGreen
                            : AppColors.expenseRed,
                      ),
                    ),
                    const SizedBox(width: 4),
                    IntrinsicWidth(
                      child: TextField(
                        controller: _amountController,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d+\.?\d{0,2}')),
                        ],
                        style: GoogleFonts.poppins(
                          fontSize: 40,
                          fontWeight: FontWeight.w700,
                          color: _isIncome
                              ? AppColors.incomeGreen
                              : AppColors.expenseRed,
                        ),
                        decoration: InputDecoration(
                          hintText: '0',
                          hintStyle: GoogleFonts.poppins(
                            fontSize: 40,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textSecondary
                                .withValues(alpha: 0.4),
                          ),
                          border: InputBorder.none,
                          filled: false,
                          contentPadding: EdgeInsets.zero,
                        ),
                        textAlign: TextAlign.center,
                        autofocus: widget.existing == null,
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 300.ms, delay: 50.ms),

              const SizedBox(height: 28),

              // Title
              TextField(
                controller: _titleController,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Iconsax.edit, size: 18),
                  hintText: 'Title (e.g. Lunch at Café)',
                  labelText: 'Title',
                ),
                style: GoogleFonts.poppins(fontSize: 14),
              ).animate().fadeIn(duration: 300.ms, delay: 80.ms),

              const SizedBox(height: 14),

              // Category selector
              Text(
                'Category',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _categories.map((cat) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: CategoryChip(
                        category: cat,
                        selected: _selectedCategory == cat,
                        onTap: (c) =>
                            setState(() => _selectedCategory = c),
                      ),
                    );
                  }).toList(),
                ),
              ).animate().fadeIn(duration: 300.ms, delay: 120.ms),

              const SizedBox(height: 14),

              // Date picker
              GestureDetector(
                onTap: _pickDate,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.cardDark
                        : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark
                          ? AppColors.border
                          : const Color(0xFFE2E8F0),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Iconsax.calendar,
                          size: 18, color: AppColors.primary),
                      const SizedBox(width: 10),
                      Text(
                        Formatter.date(_selectedDate),
                        style: GoogleFonts.poppins(fontSize: 14),
                      ),
                      const Spacer(),
                      Icon(Iconsax.arrow_right_3,
                          size: 16,
                          color: AppColors.textSecondary),
                    ],
                  ),
                ),
              ).animate().fadeIn(duration: 300.ms, delay: 150.ms),

              const SizedBox(height: 14),

              // Note (optional)
              TextField(
                controller: _noteController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Iconsax.note, size: 18),
                  hintText: 'Add a note (optional)',
                  labelText: 'Note',
                ),
                style: GoogleFonts.poppins(fontSize: 14),
              ).animate().fadeIn(duration: 300.ms, delay: 180.ms),

              const SizedBox(height: 28),

              // Save button
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _saving ? null : _save,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                  ),
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: _isIncome
                            ? [
                                AppColors.incomeGreen,
                                const Color(0xFF00B894),
                              ]
                            : [
                                AppColors.primary,
                                const Color(0xFF4158D0),
                              ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      child: _saving
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2),
                            )
                          : Text(
                              widget.existing != null
                                  ? 'Update'
                                  : 'Save Transaction',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ),
              ).animate().fadeIn(duration: 300.ms, delay: 220.ms),
            ],
          ),
        ),
      ),
    );
  }
}

class _ToggleButton extends StatelessWidget {
  final String label;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  const _ToggleButton({
    required this.label,
    required this.selected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding:
            const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? color : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: selected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
