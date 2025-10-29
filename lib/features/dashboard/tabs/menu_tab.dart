import 'package:flutter/material.dart';
import 'package:monitoring_app/features/dashboard/widgets/menu_grid_item.dart';
import 'package:monitoring_app/shared/constants/app_colors.dart';

class MenuTab extends StatelessWidget {
  MenuTab({super.key});

  // Data untuk menu grid
  final List<Map<String, dynamic>> menuItems = [
    {'icon': Icons.notifications_none_rounded, 'label': 'Event Notification'},
    {'icon': Icons.face_unlock_sharp, 'label': 'Face Bank'},
    {'icon': Icons.play_circle_outline_sharp, 'label': 'Playback Video'},
    {'icon': Icons.camera_alt_outlined, 'label': 'Camera Configuration'},
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 24.0, bottom: 24.0),
      child: Column(
        children: [
          // Grid 4 Tombol Menu Utama
          GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.2,
            ),
            itemCount: menuItems.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final item = menuItems[index];
              return MenuGridItem(
                icon: item['icon'],
                label: item['label'],
                onTap: () {
                  // TODO: Implement navigation
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Navigasi ke ${item['label']}')),
                  );
                },
              );
            },
          ),
          const SizedBox(height: 16),

          // Tombol Settings & Logout
          Row(
            children: [
              // Tombol Settings
              Expanded(
                flex: 4,
                child: _buildSettingsButton(
                  context,
                  onTap: () {
                    // TODO: Implement navigation
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Navigasi ke Settings')),
                    );
                  },
                ),
              ),
              const SizedBox(width: 16),
              // Tombol Logout
              Expanded(
                flex: 1,
                child: _buildLogoutButton(
                  context,
                  onTap: () => _showLogoutDialog(context),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  // Widget helper untuk tombol Settings (full-width)
  Widget _buildSettingsButton(BuildContext context,
      {required VoidCallback onTap}) {
    return Material(
      color: kCardColor,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          height: 70, // Samakan tinggi dengan tombol logout
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.settings, size: 28, color: kPrimaryTextColor),
              const SizedBox(width: 12),
              Text('Settings', style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
        ),
      ),
    );
  }

  // Widget helper untuk tombol Logout (merah)
  Widget _buildLogoutButton(BuildContext context,
      {required VoidCallback onTap}) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: Material(
        color: kCardColor,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: const Center(
            child: Icon(Icons.power_settings_new, color: kAccentRed, size: 28),
          ),
        ),
      ),
    );
  }

  // Fungsi untuk menampilkan dialog konfirmasi logout
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: kCardColor,
          title: const Text('Konfirmasi Logout'),
          content: const Text('Apakah Anda yakin ingin keluar dari aplikasi?'),
          titleTextStyle: Theme.of(context).textTheme.titleLarge,
          contentTextStyle: Theme.of(context).textTheme.bodyMedium,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal',
                  style: TextStyle(color: kSecondaryTextColor)),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Tutup dialog
              },
            ),
            TextButton(
              child: const Text('Iya', style: TextStyle(color: kAccentRed)),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Tutup dialog
                // TODO: Implementasi logika logout di sini
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Berhasil Logout...')),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
