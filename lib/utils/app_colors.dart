import 'package:flutter/material.dart';

class AppColors {
  // Core colors
  static const Color background = Color(0xFFF8F9FA); // --background: 210 20% 98%
  static const Color foreground = Color(0xFF1A2231); // --foreground: 220 30% 15%
  
  static const Color card = Color(0xFFFFFFFF); // --card: 0 0% 100%
  
  // Brand (navy)
  static const Color primary = Color(0xFF1E2C47); // --primary: 220 40% 20%
  
  // CTA (orange Daraz-style)
  static const Color cta = Color(0xFFF37B24); // --cta: 25 90% 55%
  static const Color ctaHover = Color(0xFFE8680C); // --cta-hover: 25 90% 48%
  
  // States / Elements
  static const Color secondary = Color(0xFFEFF2F4); // --secondary: 210 20% 95%
  static const Color muted = Color(0xFFEFF2F4); // --muted: 210 20% 95%
  static const Color accentTheme = Color(0xFFFBE9B6); // --accent: 45 90% 85%
  
  static const Color destructive = Color(0xFFD82626); // --destructive: 0 70% 50%
  static const Color success = Color(0xFF2DB75B); // --success: 140 60% 45%
  static const Color warning = Color(0xFFF3BF24); // --warning: 45 90% 55%
  static const Color border = Color(0xFFE1E5E9); // --border: 210 15% 90%
  static const Color price = Color(0xFFE53B19); // --price: 10 80% 50%

  // Aliases to support existing code
  static const Color accent = cta; // Existing 'accent' was orange, maps to cta
  static const Color textPrimary = foreground; 
  static const Color textSecondary = Color(0xFF5B6270); // --muted-foreground: 220 10% 40%
}
