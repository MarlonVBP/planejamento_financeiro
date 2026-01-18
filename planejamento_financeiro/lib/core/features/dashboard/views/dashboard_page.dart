import 'package:flutter/material.dart';
import 'package:planejamento_financeiro/core/theme/app_colors.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(colorScheme),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  _buildBalanceCard(context),
                  const SizedBox(height: 32),
                  _buildSectionHeader(context, "Operações Recentes"),
                  const SizedBox(height: 16),
                  // Lista Mockada para visualização inicial
                  _buildTransactionItem(context, "Salário Mensal", "R\$ 4.500,00", true),
                  _buildTransactionItem(context, "Supermercado", "R\$ 850,00", false),
                  _buildTransactionItem(context, "Investimento FIIs", "R\$ 500,00", false),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }

  SliverAppBar _buildAppBar(ColorScheme colors) {
    return SliverAppBar(
      floating: true,
      snap: true,
      title: Row(
        children: [
          CircleAvatar(
            backgroundColor: colors.primary.withOpacity(0.2),
            child: Icon(Icons.person, color: colors.primary),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Olá, Marlon", style: TextStyle(fontSize: 14, color: colors.onSurface.withOpacity(0.6))),
              Text("Finance Planner", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: colors.onSurface)),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(icon: const Icon(Icons.notifications_outlined), onPressed: () {}),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildBalanceCard(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        // Gradiente sutil para dar profundidade
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colors.secondary,
            AppColors.greenDarkest,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: colors.primary.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Saldo Total", style: TextStyle(color: colors.onSecondary.withOpacity(0.8))),
          const SizedBox(height: 8),
          Text(
            "R\$ 3.150,00",
            style: TextStyle(
              fontSize: 36, 
              fontWeight: FontWeight.bold, 
              color: colors.onSecondary,
              height: 1.0,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              _buildMiniInfo(context, Icons.arrow_upward, "Entradas", "R\$ 4.500"),
              const SizedBox(width: 24),
              _buildMiniInfo(context, Icons.arrow_downward, "Saídas", "R\$ 1.350"),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildMiniInfo(BuildContext context, IconData icon, String label, String value) {
    final color = Theme.of(context).colorScheme.onSecondary;
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 16),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(color: color.withOpacity(0.6), fontSize: 12)),
            Text(value, style: TextStyle(color: color, fontWeight: FontWeight.w600)),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        TextButton(onPressed: () {}, child: const Text("Ver tudo")),
      ],
    );
  }

  Widget _buildTransactionItem(BuildContext context, String title, String value, bool isIncome) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surfaceContainer,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors.outline.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isIncome ? AppColors.success.withOpacity(0.1) : AppColors.error.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isIncome ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
              color: isIncome ? AppColors.success : AppColors.error,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.w600, color: colors.onSurface)),
                Text("Hoje, 10:00", style: TextStyle(fontSize: 12, color: colors.onSurface.withOpacity(0.5))),
              ],
            ),
          ),
          Text(
            isIncome ? "+ $value" : "- $value",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isIncome ? AppColors.success : colors.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}