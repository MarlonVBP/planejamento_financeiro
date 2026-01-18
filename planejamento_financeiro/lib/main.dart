import 'package:flutter/material.dart';
import 'theme/app_theme.dart';

void main() async {
  runApp(const MyFinanceApp());
}

class MyFinanceApp extends StatefulWidget {
  const MyFinanceApp({super.key});

  @override
  State<MyFinanceApp> createState() => _MyFinanceAppState();
}

class _MyFinanceAppState extends State<MyFinanceApp> {
  Color _currentSeed = AppTheme.defaultSeed;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Finance Planner',
      debugShowCheckedModeBanner: false,

      theme: AppTheme.getTheme(seedColor: _currentSeed, isDark: true),

      home: HomePage(
        onColorChange: (Color newColor) {
          setState(() {
            _currentSeed = newColor;
          });
        },
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  final Function(Color) onColorChange;

  const HomePage({super.key, required this.onColorChange});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text("Meu Planejamento")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: colors.secondary,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Saldo Atual",
                      style: TextStyle(
                        color: colors.onSecondary.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "R\$ 2.500,00",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: colors.onSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            Text(
              "Transações Recentes",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 10),

            _buildTransactionItem(
              context,
              "Supermercado",
              "- R\$ 450,00",
              isNegative: true,
            ),
            _buildTransactionItem(
              context,
              "Freelance",
              "+ R\$ 1.200,00",
              isNegative: false,
            ),

            const SizedBox(height: 30),
            Text(
              "Testar Temas Dinâmicos",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _buildColorBtn(AppTheme.defaultSeed),
                _buildColorBtn(Colors.blue),
                _buildColorBtn(Colors.purple),
                _buildColorBtn(Colors.orange),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTransactionItem(
    BuildContext context,
    String title,
    String value, {
    required bool isNegative,
  }) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isNegative
              ? colors.error.withOpacity(0.2)
              : colors.primary.withOpacity(0.2),
          child: Icon(
            isNegative ? Icons.arrow_downward : Icons.arrow_upward,
            color: isNegative ? colors.error : colors.primary,
          ),
        ),
        title: Text(title, style: TextStyle(color: colors.onSurface)),
        trailing: Text(
          value,
          style: TextStyle(
            color: isNegative ? colors.onSurface : colors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildColorBtn(Color color) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: GestureDetector(
        onTap: () => onColorChange(color),
        child: CircleAvatar(backgroundColor: color),
      ),
    );
  }
}
