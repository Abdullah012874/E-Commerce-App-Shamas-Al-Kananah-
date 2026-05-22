import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/app_colors.dart';
import '../providers/auth_provider.dart';
import '../providers/locale_provider.dart';
import '../screens/auth/login_screen.dart';
import '../screens/contact_screen.dart';
import '../screens/services_screen.dart';
import '../screens/profile_screen.dart'; // Just for routing to profile details

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final locale = ref.watch(localeProvider);
    final t = ref.watch(translationProvider);
    
    final isLoggedIn = authState.status == AuthStatus.authenticated || authState.status == AuthStatus.admin;
    final isAdmin = authState.status == AuthStatus.admin;

    return Drawer(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: AppColors.primary),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 35, color: AppColors.primary),
                ),
                const SizedBox(height: 12),
                Text(
                  isLoggedIn ? (authState.user?.fullName ?? 'User') : 'Guest',
                  style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
                if (isLoggedIn)
                  Text(
                    authState.user?.email ?? '',
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Edit Personal Details'),
            onTap: () {
              if (!isLoggedIn) {
                _showDummyMessage(context, 'Login required to edit details');
                return;
              }
              // Can navigate to edit profile page or show dialog
              _showDummyMessage(context, 'Edit profile functionality here');
            },
            enabled: isLoggedIn,
          ),
          ListTile(
            leading: const Icon(Icons.receipt_long),
            title: Text(t['my_orders'] ?? 'My Orders'),
            onTap: () {
              Navigator.pop(context);
              if (!isLoggedIn) {
                _showDummyMessage(context, t['login_required'] ?? 'Login required to view orders');
                return;
              }
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ProfileScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.miscellaneous_services),
            title: Text(t['our_services'] ?? 'Our Services'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ServicesScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.contact_mail),
            title: Text(t['contact_us'] ?? 'Contact Us'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ContactScreen()));
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(t['language'] ?? 'Language'),
            trailing: Text(locale == AppLocale.english ? 'English' : 'العربية'),
            onTap: () {
              ref.read(localeProvider.notifier).toggleLocale();
            },
          ),
          if (isLoggedIn)
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: Text(t['logout'] ?? 'Logout', style: const TextStyle(color: Colors.red)),
              onTap: () {
                ref.read(authProvider.notifier).logout();
                Navigator.of(context).pop(); // Close drawer
              },
            ),
        ],
      ),
    );
  }

  void _showDummyMessage(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  void _confirmSwitchAccount(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Switch Account'),
        content: const Text('Are you sure you want to switch accounts? You will be logged out.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(authProvider.notifier).logout();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
            child: const Text('Switch', style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }
}
