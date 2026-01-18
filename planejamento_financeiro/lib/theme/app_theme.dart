import 'package:flutter/material.dart';

class AppTheme {
  static const Color _greenDarkest = Color(0xFF051F20); // Background
  static const Color _greenDark = Color(0xFF0B2B26);    // Surface
  static const Color _greenMediumDark = Color(0xFF163832); // Container
  static const Color _greenMedium = Color(0xFF235347);  // Secondary
  static const Color _greenLight = Color(0xFF8EB69B);   // Primary
  static const Color _greenLightest = Color(0xFFDAF1DE); // Text/Icons

  static ThemeData getTheme({required Color seedColor, bool isDark = true}) {
    final bool isCustomGreen = seedColor.value == _greenMedium.value;

    final ColorScheme colorScheme = isCustomGreen
        ? _customGreenScheme
        : ColorScheme.fromSeed(
            seedColor: seedColor,
            brightness: isDark ? Brightness.dark : Brightness.light,
          );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      
      cardTheme: CardTheme(
        color: colorScheme.surfaceContainer,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: colorScheme.outline.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        centerTitle: true,
        elevation: 0,
      ),
      
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
    );
  }

  static const ColorScheme _customGreenScheme = ColorScheme(
    brightness: Brightness.dark,
    
    primary: _greenLight, 
    onPrimary: _greenDarkest,
    primaryContainer: _greenMedium,
    onPrimaryContainer: _greenLightest,

    secondary: _greenMedium,
    onSecondary: _greenLightest,
    secondaryContainer: _greenMediumDark,
    onSecondaryContainer: _greenLight,

    surface: _greenDarkest, // Fundo da tela
    onSurface: _greenLightest, // Texto principal
    surfaceContainer: _greenDark, // Cards
    
    error: Color(0xFFCF6679),
    onError: Colors.black,
    
    outline: _greenLight,
  );
  
  static Color get defaultSeed => _greenMedium;
}