import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/expense.dart';
import '../utils/constants.dart';
import '../utils/formatter.dart';

class ExpenseTile extends StatelessWidget {
  final Expense expense;
  final VoidCallback? onDelete;
  final int animationIndex;

  const ExpenseTile({
    super.key,
    required this.expense,
    this.onDelete,
    this.animationIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    final color = CategoryColors.of(expense.category);
    final icon = CategoryIcons.of(expense.category);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Widget tile = Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.border : const Color(0xFFE2E8F0),
          width: 1,
        ),
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(
          expense.title,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          '${CategoryNames.of(expense.category)} · ${Formatter.time(expense.date)}',
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${expense.isIncome ? '+' : '-'}${Formatter.currency(expense.amount)}',
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: expense.isIncome
                    ? AppColors.incomeGreen
                    : AppColors.expenseRed,
              ),
            ),
            if (expense.note != null && expense.note!.isNotEmpty)
              Text(
                expense.note!,
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
          ],
        ),
      ),
    );

    if (onDelete != null) {
      tile = Dismissible(
        key: Key(expense.id),
        direction: DismissDirection.endToStart,
        onDismissed: (_) => onDelete!(),
        background: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.expenseRed.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(16),
          ),
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          child: const Icon(Icons.delete_outline_rounded,
              color: AppColors.expenseRed, size: 24),
        ),
        child: tile,
      );
    }

    return tile
        .animate(delay: Duration(milliseconds: 40 * animationIndex))
        .fadeIn(duration: 300.ms)
        .slideX(begin: 0.15, end: 0, curve: Curves.easeOut);
  }
}
