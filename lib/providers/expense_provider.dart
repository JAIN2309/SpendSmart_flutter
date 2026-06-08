import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/expense.dart';

class ExpenseProvider extends ChangeNotifier {
  Box<Expense> get _box => Hive.box<Expense>('expenses');

  DateTime _selectedMonth = DateTime.now();
  DateTime get selectedMonth => _selectedMonth;

  void setMonth(DateTime month) {
    _selectedMonth = month;
    notifyListeners();
  }

  void previousMonth() {
    _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month - 1);
    notifyListeners();
  }

  void nextMonth() {
    _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month + 1);
    notifyListeners();
  }

  List<Expense> get allExpenses {
    final list = _box.values.toList();
    list.sort((a, b) => b.date.compareTo(a.date));
    return list;
  }

  void addExpense(Expense expense) {
    _box.put(expense.id, expense);
    notifyListeners();
  }

  void deleteExpense(String id) {
    _box.delete(id);
    notifyListeners();
  }

  List<Expense> getExpensesForMonth(DateTime month) {
    return _box.values
        .where(
          (e) => e.date.year == month.year && e.date.month == month.month,
        )
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  double totalIncome(DateTime month) => getExpensesForMonth(month)
      .where((e) => e.isIncome)
      .fold(0.0, (s, e) => s + e.amount);

  double totalExpenses(DateTime month) => getExpensesForMonth(month)
      .where((e) => !e.isIncome)
      .fold(0.0, (s, e) => s + e.amount);

  double balance(DateTime month) =>
      totalIncome(month) - totalExpenses(month);

  Map<String, double> byCategory(DateTime month) {
    final map = <String, double>{};
    for (final e in getExpensesForMonth(month).where((e) => !e.isIncome)) {
      map[e.category] = (map[e.category] ?? 0) + e.amount;
    }
    return map;
  }

  Map<DateTime, double> byDay(DateTime month) {
    final map = <DateTime, double>{};
    for (final e in getExpensesForMonth(month).where((e) => !e.isIncome)) {
      final day = DateTime(e.date.year, e.date.month, e.date.day);
      map[day] = (map[day] ?? 0) + e.amount;
    }
    return map;
  }

  List<double> last7DaysTotals() {
    final now = DateTime.now();
    return List.generate(7, (i) {
      final day = DateTime(now.year, now.month, now.day - (6 - i));
      return _box.values
          .where(
            (e) =>
                !e.isIncome &&
                e.date.year == day.year &&
                e.date.month == day.month &&
                e.date.day == day.day,
          )
          .fold(0.0, (s, e) => s + e.amount);
    });
  }

  List<double> monthlyTrend(int year) =>
      List.generate(12, (i) => totalExpenses(DateTime(year, i + 1)));

  String topCategory(DateTime month) {
    final cats = byCategory(month);
    if (cats.isEmpty) return 'other';
    return cats.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }

  double avgDailySpend(DateTime month) {
    final days = DateTime(month.year, month.month + 1, 0).day;
    final total = totalExpenses(month);
    return days == 0 ? 0 : total / days;
  }

  List<Expense> recentTransactions(int n) {
    final list = _box.values.toList()
      ..sort((a, b) => b.date.compareTo(a.date));
    return list.take(n).toList();
  }

  double get highestSingleExpense {
    final expenses = _box.values.where((e) => !e.isIncome);
    if (expenses.isEmpty) return 0;
    return expenses.map((e) => e.amount).reduce((a, b) => a > b ? a : b);
  }

  int get daysTracked {
    if (_box.isEmpty) return 0;
    return _box.values
        .map((e) => DateTime(e.date.year, e.date.month, e.date.day))
        .toSet()
        .length;
  }

  List<Expense> getFilteredExpenses({
    String? category,
    String? searchQuery,
    DateTime? month,
  }) {
    Iterable<Expense> results = _box.values;
    if (month != null) {
      results = results.where(
        (e) => e.date.year == month.year && e.date.month == month.month,
      );
    }
    if (category != null && category != 'all') {
      results = results.where((e) => e.category == category);
    }
    if (searchQuery != null && searchQuery.isNotEmpty) {
      final q = searchQuery.toLowerCase();
      results = results.where(
        (e) =>
            e.title.toLowerCase().contains(q) ||
            (e.note?.toLowerCase().contains(q) ?? false),
      );
    }
    return results.toList()..sort((a, b) => b.date.compareTo(a.date));
  }
}
