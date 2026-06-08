import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/constants.dart';
import '../utils/formatter.dart';

class BarChartWidget extends StatefulWidget {
  final List<double> data;

  const BarChartWidget({super.key, required this.data});

  @override
  State<BarChartWidget> createState() => _BarChartWidgetState();
}

class _BarChartWidgetState extends State<BarChartWidget> {
  int _touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final maxVal = widget.data.isEmpty
        ? 100.0
        : widget.data.reduce((a, b) => a > b ? a : b);

    return AspectRatio(
      aspectRatio: 1.7,
      child: BarChart(
        BarChartData(
          maxY: maxVal == 0 ? 100 : maxVal * 1.25,
          barGroups: widget.data.asMap().entries.map((e) {
            final isToday = (6 - e.key) == 0;
            final isTouched = _touchedIndex == e.key;
            return BarChartGroupData(
              x: e.key,
              barRods: [
                BarChartRodData(
                  toY: e.value == 0 ? 0.5 : e.value,
                  color: isTouched
                      ? AppColors.primary
                      : isToday
                          ? AppColors.expenseRed
                          : AppColors.expenseRed.withValues(alpha: 0.55),
                  width: 18,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(6),
                  ),
                  backDrawRodData: BackgroundBarChartRodData(
                    show: true,
                    toY: maxVal == 0 ? 100 : maxVal * 1.25,
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.04)
                        : Colors.black.withValues(alpha: 0.03),
                  ),
                ),
              ],
            );
          }).toList(),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 28,
                getTitlesWidget: (value, meta) {
                  final day = now
                      .subtract(Duration(days: 6 - value.toInt()));
                  final label = Formatter.dayOfWeekShort(day);
                  final isToday = value.toInt() == 6;
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    child: Text(
                      label,
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: isToday
                            ? FontWeight.w700
                            : FontWeight.w400,
                        color: isToday
                            ? AppColors.primary
                            : AppColors.textSecondary,
                      ),
                    ),
                  );
                },
              ),
            ),
            leftTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: maxVal == 0 ? 25 : maxVal / 4,
            getDrawingHorizontalLine: (_) => FlLine(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.05)
                  : Colors.black.withValues(alpha: 0.04),
              strokeWidth: 1,
            ),
          ),
          borderData: FlBorderData(show: false),
          barTouchData: BarTouchData(
            touchCallback: (event, response) {
              setState(() {
                if (response?.spot != null &&
                    event is! FlPointerExitEvent) {
                  _touchedIndex =
                      response!.spot!.touchedBarGroupIndex;
                } else {
                  _touchedIndex = -1;
                }
              });
            },
            touchTooltipData: BarTouchTooltipData(
              tooltipRoundedRadius: 8,
              getTooltipColor: (_) => isDark
                  ? const Color(0xFF2D333B)
                  : const Color(0xFF1A1A2E),
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                return BarTooltipItem(
                  Formatter.currency(rod.toY > 0.5 ? rod.toY : 0),
                  GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                );
              },
            ),
          ),
        ),
        swapAnimationDuration: const Duration(milliseconds: 500),
        swapAnimationCurve: Curves.easeInOut,
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 100.ms);
  }
}
