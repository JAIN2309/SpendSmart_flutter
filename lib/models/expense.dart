import 'package:hive/hive.dart';

class Expense extends HiveObject {
  String id;
  String title;
  double amount;
  String category;
  DateTime date;
  String? note;
  bool isIncome;

  Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
    this.note,
    required this.isIncome,
  });
}
