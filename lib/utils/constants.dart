import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class AppColors {
  static const Color backgroundDark = Color(0xFF0D1117);
  static const Color backgroundLight = Color(0xFFF8FAFC);
  static const Color cardDark = Color(0xFF161B22);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color primary = Color(0xFF6C63FF);
  static const Color primaryLight = Color(0xFF9D97FF);
  static const Color incomeGreen = Color(0xFF2ECC71);
  static const Color expenseRed = Color(0xFFFF6B6B);
  static const Color border = Color(0xFF30363D);
  static const Color textSecondary = Color(0xFF8B949E);
}

class CategoryColors {
  static const Map<String, Color> map = {
    'food_drinks': Color(0xFFFF6B6B),
    'transport': Color(0xFF4ECDC4),
    'shopping': Color(0xFFA78BFA),
    'health': Color(0xFF34D399),
    'entertainment': Color(0xFFFFBF24),
    'bills': Color(0xFF60A5FA),
    'education': Color(0xFFF472B6),
    'salary': Color(0xFF2ECC71),
    'other': Color(0xFF94A3B8),
  };

  static Color of(String key) => map[key] ?? const Color(0xFF94A3B8);
}

class CategoryNames {
  static const Map<String, String> map = {
    'food_drinks': 'Food & Drinks',
    'transport': 'Transport',
    'shopping': 'Shopping',
    'health': 'Health',
    'entertainment': 'Entertainment',
    'bills': 'Bills',
    'education': 'Education',
    'salary': 'Salary',
    'other': 'Other',
  };

  static String of(String key) => map[key] ?? key;
}

class CategoryIcons {
  static const Map<String, IconData> map = {
    'food_drinks': Iconsax.coffee,
    'transport': Iconsax.car,
    'shopping': Iconsax.bag,
    'health': Iconsax.health,
    'entertainment': Iconsax.game,
    'bills': Iconsax.electricity,
    'education': Iconsax.book,
    'salary': Iconsax.money_recive,
    'other': Iconsax.box,
  };

  static IconData of(String key) => map[key] ?? Iconsax.box;
}

const kExpenseCategories = [
  'food_drinks',
  'transport',
  'shopping',
  'health',
  'entertainment',
  'bills',
  'education',
  'other',
];

const kIncomeCategories = [
  'salary',
  'other',
];

const kAllCategories = [
  'food_drinks',
  'transport',
  'shopping',
  'health',
  'entertainment',
  'bills',
  'education',
  'salary',
  'other',
];
