import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/constants.dart';
import '../utils/formatter.dart';

class PieChartWidget extends StatefulWidget {
  final Map<String, double> data;

  const PieChartWidget({super.key, required this.data});

  @override
  State<PieChartWidget> createState() => _PieChartWidgetState();
}

class _PieChartWidgetState extends State<PieChartWidget> {
  int _touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    if (widget.data.isEmpty) {
      return const SizedBox.shrink();
    }

    final total = widget.data.values.fold(0.0, (a, b) => a + b);
    final entries = widget.data.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Column(
      children: [
        SizedBox(
          height: 200,
          child: Stack(
            alignment: Alignment.center,
            children: [
              PieChart(
                PieChartData(
                  sections: entries.asMap().entries.map((e) {
                    final isTouched = _touchedIndex == e.key;
                    final category = e.value.key;
                    final value = e.value.value;
                    final pct = total > 0 ? (value / total * 100) : 0;
                    final color = CategoryColors.of(category);
                    return PieChartSectionData(
                      value: value,
                      color: color,
                      radius: isTouched ? 72 : 60,
                      title: isTouched ? '${pct.toStringAsFixed(1)}%' : '',
                      titleStyle: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                      badgeWidget: null,
                    );
                  }).toList(),
                  centerSpaceRadius: 52,
                  sectionsSpace: 2,
                  pieTouchData: PieTouchData(
                    touchCallback: (event, pieTouchResponse) {
                      setState(() {
                        if (pieTouchResponse?.touchedSection != null &&
                            event is! FlPointerExitEvent) {
                          _touchedIndex = pieTouchResponse!
                              .touchedSection!.touchedSectionIndex;
                        } else {
                          _touchedIndex = -1;
                        }
                      });
                    },
                  ),
                ),
                swapAnimationDuration: const Duration(milliseconds: 400),
              ),
              // Center label
              _touchedIndex >= 0 && _touchedIndex < entries.length
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          Formatter.currency(
                              entries[_touchedIndex].value,
                              compact: true),
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          CategoryNames.of(entries[_touchedIndex].key),
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            color: AppColors.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          entries.isNotEmpty
                              ? CategoryNames.of(entries.first.key)
                              : '',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          total > 0
                              ? '${(entries.first.value / total * 100).toStringAsFixed(0)}%'
                              : '',
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        ).animate().fadeIn(duration: 500.ms),
        const SizedBox(height: 16),
        // Legend
        Wrap(
          spacing: 12,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: entries.map((e) {
            final pct = total > 0 ? (e.value / total * 100) : 0;
            return _LegendItem(
              color: CategoryColors.of(e.key),
              label: CategoryNames.of(e.key),
              percent: pct.toStringAsFixed(1),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final String percent;

  const _LegendItem({
    required this.color,
    required this.label,
    required this.percent,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          '$label $percent%',
          style: GoogleFonts.poppins(
            fontSize: 11,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
