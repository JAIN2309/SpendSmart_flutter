import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import '../providers/expense_provider.dart';
import '../utils/constants.dart';
import '../utils/formatter.dart';
import '../widgets/line_chart_widget.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedPeriod = 1; // 0=Week, 1=Month, 2=Year

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: 3, vsync: this, initialIndex: _selectedPeriod);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() => _selectedPeriod = _tabController.index);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<double> _getChartData(ExpenseProvider provider) {
    final now = DateTime.now();
    if (_selectedPeriod == 0) {
      return provider.last7DaysTotals();
    } else if (_selectedPeriod == 1) {
      final daysInMonth =
          DateTime(now.year, now.month + 1, 0).day;
      return List.generate(daysInMonth, (i) {
        final day = DateTime(now.year, now.month, i + 1);
        return provider
            .byDay(DateTime(now.year, now.month))
            .entries
            .where((e) => e.key == day)
            .fold(0.0, (s, e) => s + e.value);
      });
    } else {
      return provider.monthlyTrend(now.year);
    }
  }

  List<String> _getLabels(ExpenseProvider provider) {
    final now = DateTime.now();
    if (_selectedPeriod == 0) {
      return List.generate(7, (i) {
        final day = now.subtract(Duration(days: 6 - i));
        return Formatter.dayOfWeekShort(day);
      });
    } else if (_selectedPeriod == 1) {
      final daysInMonth =
          DateTime(now.year, now.month + 1, 0).day;
      return List.generate(daysInMonth,
          (i) => (i + 1).toString());
    } else {
      return List.generate(
          12,
          (i) => Formatter.monthShort(
              DateTime(now.year, i + 1)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Consumer<ExpenseProvider>(
      builder: (context, provider, _) {
        final now = DateTime.now();
        final currentMonth = DateTime(now.year, now.month);
        final lastMonth = DateTime(now.year, now.month - 1);
        final thisTotal = provider.totalExpenses(currentMonth);
        final lastTotal = provider.totalExpenses(lastMonth);
        final pctChange = lastTotal > 0
            ? ((thisTotal - lastTotal) / lastTotal * 100)
            : 0.0;
        final catData = provider.byCategory(currentMonth);
        final catEntries = catData.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));
        final catTotal =
            catData.values.fold(0.0, (a, b) => a + b);
        final chartData = _getChartData(provider);
        final labels = _getLabels(provider);

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
                  'Analytics',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
                ),
                bottom: TabBar(
                  controller: _tabController,
                  indicatorColor: AppColors.primary,
                  indicatorWeight: 3,
                  labelStyle: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 13),
                  unselectedLabelStyle:
                      GoogleFonts.poppins(fontSize: 13),
                  labelColor: AppColors.primary,
                  unselectedLabelColor: AppColors.textSecondary,
                  tabs: const [
                    Tab(text: 'Week'),
                    Tab(text: 'Month'),
                    Tab(text: 'Year'),
                  ],
                ),
              ),
            ],
            body: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Line chart
                _Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Spending Trend',
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 16),
                      LineChartWidget(
                          data: chartData, labels: labels),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Top stats 2x2 grid
                _TopStatsGrid(provider: provider, month: currentMonth),

                const SizedBox(height: 16),

                // Monthly comparison
                _Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Monthly Comparison',
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _MonthCompItem(
                              label: 'This Month',
                              amount: thisTotal,
                              color: AppColors.expenseRed,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _MonthCompItem(
                              label: 'Last Month',
                              amount: lastTotal,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      if (lastTotal > 0) ...[
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.center,
                          children: [
                            Icon(
                              pctChange > 0
                                  ? Iconsax.arrow_up_3
                                  : Iconsax.arrow_down_2,
                              size: 14,
                              color: pctChange > 0
                                  ? AppColors.expenseRed
                                  : AppColors.incomeGreen,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${pctChange.abs().toStringAsFixed(1)}% vs last month',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: pctChange > 0
                                    ? AppColors.expenseRed
                                    : AppColors.incomeGreen,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Category breakdown
                if (catEntries.isNotEmpty)
                  _Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Category Breakdown',
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ...catEntries.asMap().entries.map(
                              (e) => _CategoryRow(
                                category: e.value.key,
                                amount: e.value.value,
                                total: catTotal,
                                animIndex: e.key,
                              ),
                            ),
                      ],
                    ),
                  ),

                const SizedBox(height: 80),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Card extends StatelessWidget {
  final Widget child;

  const _Card({required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.border : const Color(0xFFE2E8F0),
        ),
      ),
      child: child,
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.08, end: 0);
  }
}

class _TopStatsGrid extends StatelessWidget {
  final ExpenseProvider provider;
  final DateTime month;

  const _TopStatsGrid(
      {required this.provider, required this.month});

  @override
  Widget build(BuildContext context) {
    final items = [
      _StatGridItem(
        icon: Iconsax.arrow_up_3,
        color: AppColors.expenseRed,
        label: 'Highest Expense',
        value: Formatter.currency(provider.highestSingleExpense,
            compact: true),
      ),
      _StatGridItem(
        icon: Iconsax.chart,
        color: AppColors.primary,
        label: 'Avg Daily Spend',
        value: Formatter.currency(provider.avgDailySpend(month),
            compact: true),
      ),
      _StatGridItem(
        icon: Iconsax.category,
        color: const Color(0xFFA78BFA),
        label: 'Top Category',
        value: CategoryNames.of(provider.topCategory(month)),
      ),
      _StatGridItem(
        icon: Iconsax.calendar,
        color: AppColors.incomeGreen,
        label: 'Days Tracked',
        value: '${provider.daysTracked}',
      ),
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: items
          .asMap()
          .entries
          .map(
            (e) => _Card(child: e.value)
                .animate(
                    delay: Duration(milliseconds: 60 * e.key))
                .fadeIn(duration: 300.ms),
          )
          .toList(),
    );
  }
}

class _StatGridItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final String value;

  const _StatGridItem({
    required this.icon,
    required this.color,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 11,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _MonthCompItem extends StatelessWidget {
  final String label;
  final double amount;
  final Color color;

  const _MonthCompItem({
    required this.label,
    required this.amount,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.backgroundDark
            : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: isDark
                ? AppColors.border
                : const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: GoogleFonts.poppins(
                  fontSize: 12, color: AppColors.textSecondary)),
          const SizedBox(height: 4),
          Text(
            Formatter.currency(amount, compact: true),
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryRow extends StatelessWidget {
  final String category;
  final double amount;
  final double total;
  final int animIndex;

  const _CategoryRow({
    required this.category,
    required this.amount,
    required this.total,
    required this.animIndex,
  });

  @override
  Widget build(BuildContext context) {
    final pct = total > 0 ? amount / total : 0.0;
    final color = CategoryColors.of(category);
    final icon = CategoryIcons.of(category);

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 14, color: color),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  CategoryNames.of(category),
                  style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w500),
                ),
              ),
              Text(
                '${(pct * 100).toStringAsFixed(1)}%',
                style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppColors.textSecondary),
              ),
              const SizedBox(width: 8),
              Text(
                Formatter.currency(amount, compact: true),
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: pct,
              minHeight: 6,
              backgroundColor: color.withValues(alpha: 0.12),
              valueColor: AlwaysStoppedAnimation(color),
            )
                .animate(delay: Duration(milliseconds: 80 * animIndex))
                .custom(
                  duration: 600.ms,
                  curve: Curves.easeOut,
                  builder: (context, value, child) => child,
                ),
          ),
        ],
      ),
    );
  }
}

