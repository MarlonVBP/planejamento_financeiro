import 'package:flutter/material.dart';
import 'package:planejamento_financeiro/core/theme/app_colors.dart';

class WishlistPage extends StatelessWidget {
  const WishlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Meus Objetivos"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Card de Resumo
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: theme.colorScheme.primary.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                Icon(Icons.savings, size: 40, color: theme.colorScheme.primary),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Investimento Mensal", style: theme.textTheme.labelMedium),
                      const SizedBox(height: 4),
                      Text("R\$ 500,00", style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.primary)),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: (){}, 
                  icon: const Icon(Icons.edit_outlined),
                  tooltip: "Alterar meta",
                )
              ],
            ),
          ),
          const SizedBox(height: 24),
          
          Text("Lista de Desejos", style: theme.textTheme.titleLarge),
          const SizedBox(height: 16),

          // Lista de Itens (Exemplos)
          _buildWishItem(context, "MacBook Air", 7500, 2500, AppColors.greenTeal),
          _buildWishItem(context, "Viagem Fim de Ano", 3000, 500, Colors.purple),
          _buildWishItem(context, "Cadeira Gamer", 1200, 1200, Colors.orange, isCompleted: true),
        ],
      ),
    );
  }

  Widget _buildWishItem(BuildContext context, String title, double target, double current, Color color, {bool isCompleted = false}) {
    final theme = Theme.of(context);
    final percent = (current / target).clamp(0.0, 1.0);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    isCompleted ? Icons.check_circle : Icons.star, 
                    color: color,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text(
                        isCompleted ? "Conquistado!" : "Faltam R\$ ${(target - current).toStringAsFixed(0)}",
                        style: TextStyle(
                          color: isCompleted ? AppColors.success : theme.colorScheme.onSurface.withOpacity(0.6), 
                          fontSize: 12
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  "${(percent * 100).toInt()}%",
                  style: TextStyle(fontWeight: FontWeight.bold, color: color),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Barra de Progresso Customizada
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: percent,
                minHeight: 8,
                backgroundColor: theme.colorScheme.surface,
                valueColor: AlwaysStoppedAnimation(isCompleted ? AppColors.success : color),
              ),
            ),
          ],
        ),
      ),
    );
  }
}