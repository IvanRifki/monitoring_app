import 'package:flutter/material.dart';
import 'package:monitoring_app/features/dashboard/screens/dashboard_screen.dart';
import 'package:monitoring_app/shared/theme/app_theme.dart';

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
    );
  }
}
