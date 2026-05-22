import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'search_screen.dart';
import 'cart_screen.dart';
import 'wishlist_screen.dart';
import 'profile_screen.dart';
import 'admin_dashboard.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/cart_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/locale_provider.dart';

class MainLayout extends ConsumerStatefulWidget {
  const MainLayout({super.key});

  @override
  ConsumerState<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends ConsumerState<MainLayout> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final cartItems = ref.watch(cartProvider);
    final authState = ref.watch(authProvider);
    final t = ref.watch(translationProvider);
    
    // If auth state is still loading (fetching role), show a loading screen
    if (authState.status == AuthStatus.loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final isAdmin = authState.status == AuthStatus.admin;

    final List<Widget> pages = isAdmin 
        ? [const AdminDashboardScreen(), const SearchScreen(), const ProfileScreen()]
        : [const HomeScreen(), const SearchScreen(), const CartScreen(), const WishlistScreen(), const ProfileScreen()];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        items: isAdmin 
            ? [
                BottomNavigationBarItem(icon: const Icon(Icons.dashboard), label: t['admin_dashboard'] ?? 'Dashboard'),
                BottomNavigationBarItem(icon: const Icon(Icons.search), label: t['search'] ?? 'Search'),
                BottomNavigationBarItem(icon: const Icon(Icons.person), label: t['profile'] ?? 'Profile'),
              ]
            : [
                BottomNavigationBarItem(icon: const Icon(Icons.home), label: t['home'] ?? 'Home'),
                BottomNavigationBarItem(icon: const Icon(Icons.search), label: t['search'] ?? 'Search'),
                BottomNavigationBarItem(
                  icon: badges.Badge(
                    showBadge: cartItems.isNotEmpty,
                    badgeContent: Text(
                      cartItems.length.toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    ),
                    child: const Icon(Icons.shopping_cart),
                  ),
                  label: t['cart'] ?? 'Cart',
                ),
                BottomNavigationBarItem(icon: const Icon(Icons.favorite), label: t['wishlist'] ?? 'Wishlist'),
                BottomNavigationBarItem(icon: const Icon(Icons.person), label: t['profile'] ?? 'Profile'),
              ],
      ),
    );
  }
}

