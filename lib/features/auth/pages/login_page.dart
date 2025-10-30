// lib/features/auth/pages/login_page.dart
import 'package:flutter/material.dart';
import 'package:monitoring_app/features/dashboard/screens/dashboard_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:monitoring_app/shared/constants/app_colors.dart';

class LoginPage extends StatefulWidget {
  static const route = '/login';
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    // Ujicoba dengan user & pass yang ditentukan
    if (email == 'admin@example.com' && password == 'admin123') {
      // 1. Simpan status login
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);

      // 2. Navigasi ke Dashboard dan hapus halaman login dari tumpukan
      if (mounted) {
        Navigator.of(context).pushReplacementNamed(DashboardScreen.route);
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email atau password salah.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''), // Kosongkan title agar header bersih
        elevation: 0, // Hilangkan bayangan
        backgroundColor: Colors.transparent, // Buat transparan
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.stretch, // Agar tombol bisa full-width
          children: [
            // Header dengan Logo
            _buildHeader(context),
            const SizedBox(height: 48),

            // Form Input
            _buildTextField(
              controller: _emailController,
              hintText: 'Email or Username',
              icon: Icons.person_outline,
            ),
            const SizedBox(height: 16),
            _buildTextField(
                controller: _passwordController,
                hintText: 'Password',
                icon: Icons.lock_outline,
                isPassword: true,
                isPasswordVisible: _isPasswordVisible,
                onVisibilityToggle: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                }),
            const SizedBox(height: 12),

            // Lupa Password
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  // TODO: Navigasi ke halaman lupa password
                },
                child: const Text(
                  'Forgot Password?',
                  style: TextStyle(color: kAccentBlue),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Tombol Login
            _buildLoginButton(),
            const SizedBox(height: 24),

            // Opsi Daftar
            _buildSignUpOption(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        // Menggunakan logo aplikasi dari assets
        Image.asset(
          'assets/tbilogo.png',
          height: 80,
          color: kPrimaryTextColor,
        ),
        const SizedBox(height: 16),
        Text(
          'Welcome Back!',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        Text(
          'Sign in to continue',
          style: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(color: kSecondaryTextColor),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool isPassword = false,
    bool isPasswordVisible = false,
    VoidCallback? onVisibilityToggle,
  }) {
    // Gaya input field ini sudah konsisten dengan tema aplikasi
    return TextField(
      controller: controller,
      obscureText: isPassword && !isPasswordVisible,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(icon, color: kSecondaryTextColor),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                  color: kSecondaryTextColor,
                ),
                onPressed: onVisibilityToggle,
              )
            : null,
        // Menggunakan gaya border yang sama seperti di halaman lain
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: kCardColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
        filled: true,
        fillColor: kCardColor,
      ),
    );
  }

  Widget _buildLoginButton() {
    // Tombol ini dibuat mirip dengan _DeleteBarButton di playback_detail_page.dart
    return SizedBox(
      // Bungkus dengan SizedBox agar bisa set tinggi
      height: 56,
      child: ElevatedButton(
        onPressed: _login,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2563EB), // blue-600
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: const Text(
          'Login',
          style: TextStyle(
            fontSize: 16.5,
            fontWeight: FontWeight.w800,
            letterSpacing: .2,
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpOption(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account? ",
          style: TextStyle(color: kSecondaryTextColor),
        ), // Spasi setelah tanda tanya
        GestureDetector(
          onTap: () {
            // TODO: Navigasi ke halaman sign up
          },
          child: const Text(
            'Sign Up',
            style: TextStyle(
              color: kAccentBlue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
