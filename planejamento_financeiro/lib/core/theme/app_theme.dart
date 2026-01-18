import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData getTheme({required Color seedColor, bool isDark = true}) {
    final bool isCustomGreen = seedColor.value == AppColors.greenTeal.value;
    
    // Se for a cor oficial, forçamos a paleta exata. Se não, geramos dinamicamente.
    final ColorScheme scheme = isCustomGreen
        ? _getExactGreenScheme()
        : ColorScheme.fromSeed(
            seedColor: seedColor,
            brightness: isDark ? Brightness.dark : Brightness.light,
            surface: isDark ? const Color(0xFF121212) : Colors.white,
          );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: scheme.onSurface,
          fontSize: 24,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.5,
        ),
      ),
      cardTheme: CardThemeData(
        color: scheme.surfaceContainer,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: scheme.outline.withValues(alpha: 0.1)),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  static ColorScheme _getExactGreenScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.greenLight,
      onPrimary: AppColors.greenDarkest,
      secondary: AppColors.greenTeal,
      onSecondary: AppColors.greenMint,
      tertiary: AppColors.greenMedium,
      error: AppColors.error,
      onError: AppColors.greenDarkest,
      surface: AppColors.greenDarkest,
      onSurface: AppColors.greenMint,
      surfaceContainer: AppColors.greenDark, // Usado nos Cards
      outline: AppColors.greenLight,
    );
  }
}