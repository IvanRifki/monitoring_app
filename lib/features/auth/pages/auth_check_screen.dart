// lib/features/auth/pages/auth_check_screen.dart
import 'package:flutter/material.dart';
import 'package:monitoring_app/features/auth/pages/login_page.dart';
import 'package:monitoring_app/features/dashboard/screens/dashboard_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthCheckScreen extends StatefulWidget {
  const AuthCheckScreen({super.key});

  @override
  State<AuthCheckScreen> createState() => _AuthCheckScreenState();
}

class _AuthCheckScreenState extends State<AuthCheckScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (mounted) {
      if (isLoggedIn) {
        Navigator.of(context).pushReplacementNamed(DashboardScreen.route);
      } else {
        Navigator.of(context).pushReplacementNamed(LoginPage.route);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Tampilkan loading indicator selagi memeriksa status login
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
