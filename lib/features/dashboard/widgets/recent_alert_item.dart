import 'package:flutter/material.dart';
import 'package:monitoring_app/shared/constants/app_colors.dart';

class RecentAlertItem extends StatelessWidget {
  const RecentAlertItem({
    super.key,
    this.imageUrl1,
    this.imageUrl2,
    required this.name,
    required this.date,
    required this.status,
  });

  final String? imageUrl1;
  final String? imageUrl2;
  final String name;
  final String date;
  final String status;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            // Gambar
            Row(
              children: [
                _buildImage(imageUrl1),
                const SizedBox(width: 8),
                _buildImage(imageUrl2),
              ],
            ),
            const SizedBox(width: 12),
            // Info Teks
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(date,
                      style: const TextStyle(
                          fontSize: 12, color: kSecondaryTextColor)),
                ],
              ),
            ),
            // Status
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: kAccentBlue.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                status,
                style: const TextStyle(
                    color: kAccentBlue,
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper untuk menampilkan gambar atau placeholder
  Widget _buildImage(String? imageUrl) {
    Widget placeholder = Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: kBackgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(Icons.person, color: kSecondaryTextColor),
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: imageUrl != null
          ? Image.network(
              imageUrl,
              width: 40,
              height: 40,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => placeholder,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return placeholder;
              },
            )
          : placeholder,
    );
  }
}
