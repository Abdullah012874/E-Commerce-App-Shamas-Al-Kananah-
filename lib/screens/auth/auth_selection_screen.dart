import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'login_screen.dart';
import 'registration_screen.dart';
import '../checkout_screen.dart';
import '../../providers/locale_provider.dart';

class AuthSelectionScreen extends ConsumerWidget {
  const AuthSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(translationProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(t['checkout'] ?? 'Checkout'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.shopping_cart_checkout, size: 100, color: Colors.orange),
            const SizedBox(height: 32),
            Text(
              t['app_name'] ?? 'Shams Al Kananah',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 48),
            _buildButton(
              context,
              t['login'] ?? 'Login',
              Colors.orange,
              () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginScreen())),
            ),
            const SizedBox(height: 16),
            _buildButton(
              context,
              t['signup'] ?? 'Sign Up',
              Colors.orange.shade700,
              () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegistrationScreen())),
            ),
            const SizedBox(height: 16),
            _buildButton(
              context,
              t['guest'] ?? 'Continue as Guest',
              Colors.grey.shade700,
              () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CheckoutScreen())),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String label, Color color, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: onPressed,
        child: Text(label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
