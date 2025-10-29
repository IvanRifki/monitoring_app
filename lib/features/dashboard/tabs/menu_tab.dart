// lib/features/dashboard/tabs/menu_tab.dart
import 'package:flutter/material.dart';
import 'package:monitoring_app/features/dashboard/widgets/menu_grid_item.dart';
import 'package:monitoring_app/shared/constants/app_colors.dart';

// IMPORT halaman playback (pakai yang punya constant route)
import 'package:monitoring_app/features/playback/pages/playback_list_page.dart';

class MenuTab extends StatelessWidget {
  MenuTab({super.key});

  // Data untuk menu grid
  final List<Map<String, dynamic>> menuItems = const [
    {'icon': Icons.notifications_none_rounded, 'label': 'Event Notification'},
    {'icon': Icons.face_unlock_sharp,           'label': 'Face Bank'},
    {'icon': Icons.play_circle_outline_sharp,   'label': 'Playback Video'},
    {'icon': Icons.camera_alt_outlined,         'label': 'Camera Configuration'},
  ];

  // Peta label -> named route (biar nggak if-else panjang)
  static const Map<String, String> _routeMap = {
    'Playback Video': PlaybackListPage.route,
    // Tambahkan rute lain jika sudah siap:
    // 'Event Notification': EventNotificationPage.route,
    // 'Face Bank': FaceBankPage.route,
    // 'Camera Configuration': CameraConfigPage.route,
  };

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
                icon: item['icon'] as IconData,
                label: item['label'] as String,
                onTap: () => _onMenuTap(context, item['label'] as String),
              );
            },
          ),
          const SizedBox(height: 16),

          // Tombol Settings & Logout
          Row(
            children: [
              Expanded(
                flex: 4,
                child: _buildSettingsButton(
                  context,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Navigasi ke Settings')),
                    );
                  },
                ),
              ),
              const SizedBox(width: 16),
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

  // === NAV HANDLER ===
  void _onMenuTap(BuildContext context, String label) {
    final routeName = _routeMap[label];
    if (routeName != null) {
      Navigator.of(context).pushNamed(routeName);
    } else {
      // fallback sementara bila belum ada rute
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Navigasi ke $label belum diimplementasikan')),
      );
    }
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
          height: 70,
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

  // Dialog konfirmasi logout
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
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            TextButton(
              child: const Text('Iya', style: TextStyle(color: kAccentRed)),
              onPressed: () {
                Navigator.of(dialogContext).pop();
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