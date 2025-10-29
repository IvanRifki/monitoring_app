import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:monitoring_app/shared/constants/app_colors.dart';

class AlertChartSection extends StatelessWidget {
  const AlertChartSection({
    super.key,
    required this.title,
    required this.dateRange,
    required this.barGroups,
    this.maxY = 20,
  });

  final String title;
  final String dateRange;
  final List<BarChartGroupData> barGroups;
  final double maxY;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Judul dan Tanggal
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: kBackgroundColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today,
                          size: 12, color: kSecondaryTextColor),
                      const SizedBox(width: 4),
                      Text(dateRange,
                          style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Widget Chart
            SizedBox(
              height: 150,
              child: _buildBarChart(context),
            ),
            const SizedBox(height: 12),

            // Legenda Chart
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegendItem(kAccentBlue, 'Unknown Person'),
                const SizedBox(width: 16),
                _buildLegendItem(kAccentRed, 'RedList Person'),
              ],
            )
          ],
        ),
      ),
    );
  }

  // Widget helper untuk legenda
  Widget _buildLegendItem(Color color, String text) {
    return Row(
      children: [
        Container(width: 12, height: 12, color: color),
        const SizedBox(width: 4),
        Text(text,
            style: const TextStyle(fontSize: 12, color: kSecondaryTextColor)),
      ],
    );
  }

  // Konfigurasi Bar Chart (fl_chart)
  Widget _buildBarChart(BuildContext context) {
    return BarChart(
      BarChartData(
        maxY: maxY,
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                rod.toY.round().toString(),
                const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              );
            },
          ),
          touchCallback: (event, response) {},
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  space: 4,
                  child: Text(
                    (value.toInt() + 1).toString(),
                    style: const TextStyle(
                        color: kSecondaryTextColor, fontSize: 10),
                  ),
                );
              },
              reservedSize: 18,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value.toInt() % 5 != 0) return Container();
                return Text(
                  value.toInt().toString(),
                  style:
                      const TextStyle(color: kSecondaryTextColor, fontSize: 10),
                );
              },
              reservedSize: 28,
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 5,
          getDrawingHorizontalLine: (value) => const FlLine(
            color: kCardColor,
            strokeWidth: 1,
          ),
        ),
        barGroups: barGroups,
        alignment: BarChartAlignment.spaceBetween,
      ),
    );
  }
}
