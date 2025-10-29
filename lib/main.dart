// lib/main.dart
import 'package:flutter/material.dart';
import 'package:monitoring_app/shared/theme/app_theme.dart';
import 'package:monitoring_app/features/dashboard/screens/dashboard_screen.dart';

// IMPORT playback pages + model
import 'package:monitoring_app/features/playback/models/playback_item.dart';
import 'package:monitoring_app/features/playback/pages/playback_list_page.dart';
import 'package:monitoring_app/features/playback/pages/playback_detail_page.dart';

void main() {
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
      home: const DashboardScreen(),

      // === routes global (pakai constant dari page) ===
      routes: {
        PlaybackListPage.route: (_) => const PlaybackListPage(),
        PlaybackDetailPage.route: (ctx) {
          final item = ModalRoute.of(ctx)!.settings.arguments as PlaybackItem;
          return PlaybackDetailPage(item: item);
        },
      },
    );
  }
}
