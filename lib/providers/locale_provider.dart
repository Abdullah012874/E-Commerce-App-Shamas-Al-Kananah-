import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppLocale { english, arabic }

class LocaleNotifier extends Notifier<AppLocale> {
  static const String _key = 'selected_language';

  @override
  AppLocale build() {
    _loadLocale();
    return AppLocale.english;
  }

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLocale = prefs.getString(_key);
    if (savedLocale != null) {
      state = savedLocale == 'arabic' ? AppLocale.arabic : AppLocale.english;
    }
  }

  Future<void> setLocale(AppLocale locale) async {
    state = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, locale == AppLocale.arabic ? 'arabic' : 'english');
  }

  void toggleLocale() {
    setLocale(state == AppLocale.english ? AppLocale.arabic : AppLocale.english);
  }
}

final localeProvider = NotifierProvider<LocaleNotifier, AppLocale>(LocaleNotifier.new);

final translationProvider = Provider<Map<String, String>>((ref) {
  final locale = ref.watch(localeProvider);
  if (locale == AppLocale.arabic) {
    return {
      'app_name': 'شمس الكنانة',
      'home': 'الرئيسية',
      'search': 'بحث',
      'cart': 'عربة التسوق',
      'wishlist': 'المفضلة',
      'profile': 'الملف الشخصي',
      'categories': 'الفئات',
      'popular_products': 'المنتجات الشائعة',
      'checkout': 'إتمام الشراء',
      'login': 'تسجيل الدخول',
      'signup': 'إنشاء حساب',
      'guest': 'المتابعة كضيف',
      'logout': 'تسجيل الخروج',
      'admin_dashboard': 'لوحة التحكم',
      'my_orders': 'طلباتي',
      'contact_us': 'اتصل بنا',
      'our_services': 'خدماتنا',
      'language': 'اللغة',
      'total': 'المجموع',
      'sar': 'ريال',
    };
  }
  return {
    'app_name': 'Shams Al Kananah',
    'home': 'Home',
    'search': 'Search',
    'cart': 'Cart',
    'wishlist': 'Wishlist',
    'profile': 'Profile',
    'categories': 'Categories',
    'popular_products': 'Popular Products',
    'checkout': 'Checkout',
    'login': 'Login',
    'signup': 'Sign Up',
    'guest': 'Continue as Guest',
    'logout': 'Logout',
    'admin_dashboard': 'Admin Dashboard',
    'my_orders': 'My Orders',
    'contact_us': 'Contact Us',
    'our_services': 'Our Services',
    'language': 'Language',
    'total': 'Total',
    'sar': 'SAR',
  };
});

