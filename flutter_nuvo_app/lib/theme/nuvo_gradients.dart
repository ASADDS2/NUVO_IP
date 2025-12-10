import 'package:flutter/material.dart';

class NuvoGradients {
  // Backgrounds
  static const Color blackBackground = Color(0xFF000000);
  static const Color cardBackground = Color(0xFF111111);

  // Header Gradient (Purple top to dark)
  static const LinearGradient headerGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF2A1B3D), // Purple dark
      Color(0xFF0F1512), // Dark Greenish/Black
    ],
  );

  // Balance Text Gradient (Purple to Blue/White)
  static const LinearGradient balanceGradient = LinearGradient(
    colors: [
      Color(0xFF8B5CF6), // Purple
      Color(0xFF3B82F6), // Blue
      Colors.white,
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Action Button Gradients
  static const LinearGradient actionSend = LinearGradient(
    colors: [Color(0xFF8B5CF6), Color(0xFF3B82F6)], // Purple -> Blue
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient actionRecharge = LinearGradient(
    colors: [Color(0xFF3B82F6), Color(0xFF06B6D4)], // Blue -> Cyan
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient actionWithdraw = LinearGradient(
    colors: [Color(0xFFF97316), Color(0xFFFF4C4C)], // Orange -> Red
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient actionLoans = LinearGradient(
    colors: [Color(0xFF8B5CF6), Color(0xFF6366F1)], // Purple -> Indigo
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient actionPool = LinearGradient(
    colors: [Color(0xFF8B5CF6), Color(0xFF8B5CF6)], // Green -> Teal
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Transaction Icons Backgrounds
  static const Color transactionIconBgPositive = Color(0xFF0F291E);
  static const Color transactionIconBgNegative = Color(0xFF2A1215);

  static const Color greenText = Color(0xFF8B5CF6);
  static const Color redText = Color(0xFFFF4C4C);
  static const Color purpleText = Color(0xFF8B5CF6);

  // Pool Progress Gradient
  static const LinearGradient poolProgressBar = LinearGradient(
    colors: [Color(0xFF8B5CF6), Color(0xFF8B5CF6)], // Purple -> Teal
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}
