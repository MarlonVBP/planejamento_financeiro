import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:planejamento_financeiro/core/features/dashboard/views/dashboard_page.dart';
import 'firebase_options.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const FinanceApp());
}

class FinanceApp extends StatelessWidget {
  const FinanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Aqui usamos a cor "Teal" como semente, que ativa o modo "Custom Green"
    // definido no app_theme.dart para ser fiel à sua imagem.
    return MaterialApp(
      title: 'Finance Planner',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.getTheme(seedColor: AppColors.greenTeal, isDark: true),
      home: const DashboardPage(),
    );
  }
}