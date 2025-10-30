import 'package:flutter/material.dart';
import 'package:monitoring_app/features/dashboard/tabs/charts_tab.dart'; // Ganti
import 'package:monitoring_app/features/dashboard/tabs/menu_tab.dart'; // Ganti
import 'package:monitoring_app/features/dashboard/widgets/animated_gradient_button.dart'; // Ganti

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  // Definisikan route name agar bisa dipanggil dari mana saja
  static const route = '/dashboard';

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.all(12.0),
            // Ganti dengan logo Anda
            child: Image.asset('assets/tbilogo.png'),
          ),
          title: const Text('Dashboard'),
          centerTitle: true,
          actions: const [
            // Avatar pengguna, tanpa dropdown
            Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: CircleAvatar(
                backgroundImage: AssetImage('assets/avatar.png'),
              ),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              const SizedBox(height: 16),
              // Pindahkan widget tombol gradien ke file-nya sendiri
              const AnimatedGradientButton(),
              const SizedBox(height: 24),
              const TabBar(
                tabs: [
                  Tab(text: 'Menus'),
                  Tab(text: 'Charts'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    // Panggil widget Tab dari file terpisah
                    MenuTab(),
                    const ChartsTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
