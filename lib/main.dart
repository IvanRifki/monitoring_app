// lib/main.dart
import 'package:flutter/material.dart';
import 'package:monitoring_app/features/auth/pages/auth_check_screen.dart';
import 'package:monitoring_app/features/auth/pages/login_page.dart';
import 'package:monitoring_app/shared/theme/app_theme.dart';
import 'package:monitoring_app/features/dashboard/screens/dashboard_screen.dart';

// IMPORT playback pages + model
import 'package:monitoring_app/features/playback/models/playback_item.dart';
import 'package:monitoring_app/features/playback/pages/playback_list_page.dart';
import 'package:monitoring_app/features/playback/pages/playback_detail_page.dart';

void main() {
  // Jalankan aplikasi dengan MyApp sebagai root
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Monitoring Dashboard',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      // Halaman awal selalu AuthCheckScreen, yang akan mengarahkan ke halaman yang benar.
      home: const AuthCheckScreen(),

      // === routes global (pakai constant dari page) ===
      routes: {
        LoginPage.route: (_) => const LoginPage(),
        DashboardScreen.route: (_) => const DashboardScreen(),
        PlaybackListPage.route: (_) => const PlaybackListPage(),
        PlaybackDetailPage.route: (ctx) {
          final item = ModalRoute.of(ctx)!.settings.arguments as PlaybackItem;
          return PlaybackDetailPage(item: item);
        },
      },
    );
  }
}
