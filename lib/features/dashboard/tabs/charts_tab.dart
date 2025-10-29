import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:monitoring_app/features/dashboard/widgets/alert_chart_section.dart'; // Ganti
import 'package:monitoring_app/features/dashboard/widgets/recent_alert_item.dart'; // Ganti
import 'package:monitoring_app/features/dashboard/widgets/summary_card.dart'; // Ganti
import 'package:monitoring_app/shared/constants/app_colors.dart'; // Ganti

class ChartsTab extends StatelessWidget {
  const ChartsTab({super.key});

  // Di aplikasi profesional, data ini akan datang dari ViewModel/Provider,
  // bukan hardcoded di sini.
  final summaryData = const [
    {
      'value': '7/20',
      'label': 'Total Active Camera',
      'icon': Icons.videocam,
      'color': kAccentBlue,
      'isHighlighted': false
    },
    {
      'value': '11',
      'label': 'Reports Created',
      'icon': Icons.article,
      'color': kSecondaryTextColor,
      'isHighlighted': false
    },
    {
      'value': '5',
      'label': 'Unknown Person',
      'icon': Icons.person_search,
      'color': kSecondaryTextColor,
      'isHighlighted': false
    },
    {
      'value': '3',
      'label': 'Redlist Detected',
      'icon': Icons.warning_amber,
      'color': kAccentRed,
      'isHighlighted': true
    },
    {
      'value': '3',
      'label': 'Known Person',
      'icon': Icons.person,
      'color': kAccentBlue,
      'isHighlighted': true
    },
    {
      'value': '11',
      'label': 'Total Detected',
      'icon': Icons.visibility,
      'color': kSecondaryTextColor,
      'isHighlighted': false
    },
  ];

  final weeklyChartData = const [
    {'x': 0, 'y1': 5.0, 'y2': 3.0},
    {'x': 1, 'y1': 2.0, 'y2': 4.0},
    {'x': 2, 'y1': 0.0, 'y2': 0.0},
    {'x': 3, 'y1': 4.0, 'y2': 1.0},
    {'x': 4, 'y1': 0.0, 'y2': 7.0},
    {'x': 5, 'y1': 2.0, 'y2': 6.0},
    {'x': 6, 'y1': 7.0, 'y2': 0.0},
  ];

  // (Data untuk annual chart, dll)

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 24.0, bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Grid Summary Cards
          GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.5,
            ),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: summaryData.length,
            itemBuilder: (context, index) {
              final item = summaryData[index];
              return SummaryCard(
                value: item['value'] as String,
                label: item['label'] as String,
                icon: item['icon'] as IconData,
                color: item['color'] as Color,
                isHighlighted: item['isHighlighted'] as bool,
              );
            },
          ),
          const SizedBox(height: 24),

          // 2. Weekly Chart Section
          AlertChartSection(
            title: 'Weekly Alert Trends',
            dateRange: '4 Oct 2025 - 12 Oct 2025',
            barGroups: weeklyChartData
                .map((data) => _buildBarGroup(data['x'] as int,
                    data['y1'] as double, data['y2'] as double))
                .toList(),
          ),
          const SizedBox(height: 24),

          // 3. Annualy Chart Section (data bisa diganti)
          AlertChartSection(
            title: 'Annualy Alert Trends',
            dateRange: '2025',
            barGroups: weeklyChartData
                .map((data) => _buildBarGroup(data['x'] as int,
                    data['y1'] as double, data['y2'] as double))
                .toList(),
          ),
          const SizedBox(height: 24),

          // 4. Recent Alerts List
          Text('Recent Alert Trends',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          const RecentAlertItem(
            imageUrl1: 'https://i.imgur.com/gkyNb4u.jpeg',
            imageUrl2: 'https://i.imgur.com/OzA13uG.png',
            name: 'Target FullName Here',
            date: '10 Oct 2025 | 09:12:23',
            status: 'Nofrol',
          ),
          // ... item lainnya ...
        ],
      ),
    );
  }

  // Logika untuk membuat BarGroup bisa tetap di sini atau dipindah ke file chart
  BarChartGroupData _buildBarGroup(int x, double y1, double y2) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
            toY: y1,
            color: kAccentBlue,
            width: 7,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4))),
        BarChartRodData(
            toY: y2,
            color: kAccentRed,
            width: 7,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4))),
      ],
      barsSpace: 4,
    );
  }
}
