import 'package:flutter/material.dart';
import 'package:monitoring_app/shared/constants/app_colors.dart'; // Ganti

class SummaryCard extends StatelessWidget {
  const SummaryCard({
    super.key,
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
    this.isHighlighted = false,
  });

  final String value;
  final String label;
  final IconData icon;
  final Color color;
  final bool isHighlighted;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      color: isHighlighted ? color : kCardColor,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon,
                    color: isHighlighted ? Colors.white : color, size: 20),
                Text(
                  value,
                  style: textTheme.titleLarge?.copyWith(
                    color: isHighlighted ? Colors.white : color,
                    fontSize: 24,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: textTheme.bodySmall?.copyWith(
                    color: isHighlighted ? Colors.white70 : kSecondaryTextColor,
                    fontSize: 12,
                  ),
                ),
                Text(
                  'See Detail >',
                  style: textTheme.bodySmall?.copyWith(
                    color: isHighlighted ? Colors.white : color,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
