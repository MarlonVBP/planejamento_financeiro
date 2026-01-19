import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:planejamento_financeiro/core/features/home/views/home_page.dart';
import 'firebase_options.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/app_colors.dart';

void main() async {
  // Garante que o motor do Flutter esteja pronto
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicia o Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const FinanceApp());
}

class FinanceApp extends StatelessWidget {
  const FinanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Finance Planner',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.getTheme(seedColor: AppColors.greenTeal, isDark: true),
      home: const HomePage(),
    );
  }
}