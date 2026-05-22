import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../utils/app_colors.dart';
import '../../services/auth_service.dart';
import '../main_layout.dart';

class AuthenticatingScreen extends ConsumerStatefulWidget {
  final String username; // This is the email
  final String password;

  const AuthenticatingScreen({
    super.key,
    required this.username,
    required this.password,
  });

  @override
  ConsumerState<AuthenticatingScreen> createState() => _AuthenticatingScreenState();
}

class _AuthenticatingScreenState extends ConsumerState<AuthenticatingScreen> {
  @override
  void initState() {
    super.initState();
    _authenticate();
  }

  Future<void> _authenticate() async {
    try {
      // Use the AuthService to sign in with Firebase
      final authService = AuthService();
      await authService.loginUser(
        email: widget.username,
        password: widget.password,
      );

      // The AuthNotifier in auth_provider.dart is already listening to 
      // authStateChanges and will handle the app state automatically.
      
      if (!mounted) return;
      _navigateToHome();
      
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      
      String message = 'Login failed';
      if (e.code == 'user-not-found' || e.code == 'invalid-credential') {
        message = 'Invalid email or password.';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password provided.';
      } else if (e.code == 'invalid-email') {
        message = 'The email address is badly formatted.';
      }
      
      Navigator.of(context).pop(message);
    } catch (e) {
      if (!mounted) return;
      Navigator.of(context).pop('An unexpected error occurred. Please try again.');
    }
  }

  void _navigateToHome() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const MainLayout()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 3,
            ),
            SizedBox(height: 24),
            Text(
              'Authenticating...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
