import 'package:flutter/material.dart';

class AppColors {
  // Colores principales
  static const Color primary = Color.fromARGB(255, 62, 157, 8);
  static const Color primaryDark = Color.fromARGB(255, 46, 117, 6);
  static const Color primaryLight = Color.fromARGB(255, 76, 209, 1);

  // Colores de fondo
  static const Color background = Color(0xFF0A0A0A);
  static const Color surface = Color(0xFF1A1A1A);
  static const Color surfaceLight = Color(0xFF2A2A2A);

  // Colores de texto
  static const Color textPrimary = Colors.white;
  static Color textSecondary = Colors.white.withOpacity(0.7);
  static Color textTertiary = Colors.white.withOpacity(0.6);
  static Color textDisabled = Colors.white.withOpacity(0.4);

  // Colores de estado
  static const Color success = Color(0x4cd101);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFFBBF24);
  static const Color info = Color(0xFF3B82F6);

  // Colores de borde
  static Color borderColor = Colors.white.withOpacity(0.2);
  static Color borderColorLight = Colors.white.withOpacity(0.1);

  // Colores deshabilitados
  static const Color disabledBackground = Color(0xFF424242);
  static Color disabledText = Colors.grey.shade600;
}