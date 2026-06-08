import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import '../models/expense.dart';
import '../providers/expense_provider.dart';
import '../utils/constants.dart';
import '../utils/formatter.dart';
import '../widgets/category_chip.dart';
import '../widgets/empty_state.dart';
import '../widgets/expense_tile.dart';
import 'add_expense_screen.dart';

class TransactionsScreen extends StatefulWidget {
  final bool asFullPage;

  const TransactionsScreen({super.key, this.asFullPage = false});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCategory = 'all';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openAdd(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AddExpenseScreen(),
    );
  }

  void _confirmDelete(BuildContext context, Expense expense) {
    final provider = context.read<ExpenseProvider>();
    provider.deleteExpense(expense.id);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('Deleted "${expense.title}"',
              style: GoogleFonts.poppins()),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.cardDark,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
          action: SnackBarAction(
            label: 'Undo',
            textColor: AppColors.primary,
            onPressed: () => provider.addExpense(expense),
          ),
        ),
      );
  }

  Map<String, List<Expense>> _grouped(List<Expense> expenses) {
    final map = <String, List<Expense>>{};
    for (final e in expenses) {
      final key = Formatter.dayLabel(e.date);
      map.putIfAbsent(key, () => []).add(e);
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Consumer<ExpenseProvider>(
      builder: (context, provider, _) {
        final filtered = provider.getFilteredExpenses(
          category: _selectedCategory == 'all' ? null : _selectedCategory,
          searchQuery: _searchQuery,
        );
        final grouped = _grouped(filtered);
        final groupKeys = grouped.keys.toList();

        Widget body = CustomScrollView(
          slivers: [
            // Search bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: TextField(
                  controller: _searchController,
                  onChanged: (v) => setState(() => _searchQuery = v),
                  decoration: InputDecoration(
                    hintText: 'Search transactions…',
                    prefixIcon: const Icon(Iconsax.search_normal,
                        size: 18, color: AppColors.textSecondary),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Iconsax.close_circle,
                                size: 18),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                  ),
                  style: GoogleFonts.poppins(fontSize: 14),
                ).animate().fadeIn(duration: 300.ms),
              ),
            ),

            // Filter chips
            SliverToBoxAdapter(
              child: SizedBox(
                height: 52,
                child: ListView(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  scrollDirection: Axis.horizontal,
                  children: [
                    AllCategoryChip(
                      selected: _selectedCategory == 'all',
                      onTap: () =>
                          setState(() => _selectedCategory = 'all'),
                    ),
                    const SizedBox(width: 8),
                    ...kAllCategories.map(
                      (cat) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: CategoryChip(
                          category: cat,
                          selected: _selectedCategory == cat,
                          onTap: (c) =>
                              setState(() => _selectedCategory = c),
                        ),
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 300.ms, delay: 50.ms),
            ),

            if (filtered.isEmpty)
              SliverFillRemaining(
                child: EmptyState(
                  title: 'No transactions found',
                  subtitle: _searchQuery.isNotEmpty
                      ? 'Try a different search term'
                      : 'Tap + to add your first transaction',
                  onAction: _searchQuery.isEmpty
                      ? () => _openAdd(context)
                      : null,
                ),
              )
            else
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final key = groupKeys[index];
                    final items = grouped[key]!;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(
                              20, 20, 20, 8),
                          child: Row(
                            children: [
                              Text(
                                key,
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                Formatter.currency(
                                  items
                                      .where((e) => !e.isIncome)
                                      .fold(0.0,
                                          (s, e) => s + e.amount),
                                ),
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: AppColors.expenseRed,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ...items.asMap().entries.map(
                              (e) => ExpenseTile(
                                expense: e.value,
                                animationIndex: e.key,
                                onDelete: () =>
                                    _confirmDelete(context, e.value),
                              ),
                            ),
                      ],
                    );
                  },
                  childCount: groupKeys.length,
                ),
              ),

            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        );

        if (widget.asFullPage) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Transactions',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
              ),
              leading: IconButton(
                icon: const Icon(Iconsax.arrow_left_2),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            body: body,
            floatingActionButton: _Fab(onTap: () => _openAdd(context)),
          );
        }

        return Scaffold(
          backgroundColor: isDark
              ? AppColors.backgroundDark
              : AppColors.backgroundLight,
          body: NestedScrollView(
            headerSliverBuilder: (_, innerBoxIsScrolled) => [
              SliverAppBar(
                pinned: true,
                backgroundColor: isDark
                    ? AppColors.backgroundDark
                    : AppColors.backgroundLight,
                elevation: 0,
                title: Text(
                  'Transactions',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
            body: body,
          ),
          floatingActionButton: _Fab(onTap: () => _openAdd(context)),
        );
      },
    );
  }
}

class _Fab extends StatelessWidget {
  final VoidCallback onTap;

  const _Fab({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onTap,
      backgroundColor: AppColors.primary,
      shape: const CircleBorder(),
      child: const Icon(Iconsax.add, color: Colors.white),
    );
  }
}
