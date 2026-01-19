import 'package:flutter/material.dart';
import 'package:planejamento_financeiro/core/theme/app_colors.dart';
import 'package:planejamento_financeiro/data/models/transaction_model.dart';
import 'package:planejamento_financeiro/data/services/transaction_service.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final transactionService = TransactionService();

    // StreamBuilder "escuta" o banco de dados
    return StreamBuilder<List<TransactionModel>>(
      stream: transactionService.getTransactionsStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("Nenhuma transação ainda."));
        }

        final transactions = snapshot.data!;
        
        // Cálculo Dinâmico do Saldo
        final totalBalance = transactions.fold(0.0, (sum, item) {
          return item.isIncome ? sum + item.amount : sum - item.amount;
        });

        // Cálculos de Entradas e Saídas
        final totalIncome = transactions
            .where((t) => t.isIncome)
            .fold(0.0, (sum, t) => sum + t.amount);
            
        final totalExpense = transactions
            .where((t) => !t.isIncome)
            .fold(0.0, (sum, t) => sum + t.amount);

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              _buildAppBar(context),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      // Passamos os valores calculados para o Card
                      _buildBalanceCard(context, totalBalance, totalIncome, totalExpense),
                      const SizedBox(height: 32),
                      _buildSectionHeader(context, "Operações Recentes"),
                      const SizedBox(height: 16),
                      
                      // Lista Dinâmica
                      ...transactions.map((t) => _buildTransactionItem(context, t)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // --- Widgets Auxiliares (Atualizados para receber dados) ---

  SliverAppBar _buildAppBar(BuildContext context) {
    // Mesma implementação anterior, apenas simplificada aqui
    final colors = Theme.of(context).colorScheme;
    return SliverAppBar(
      floating: true,
      title: Text("Olá, Marlon", style: TextStyle(color: colors.onSurface)),
    );
  }

  Widget _buildBalanceCard(BuildContext context, double balance, double income, double expense) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colors.secondary, AppColors.greenDarkest],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Saldo Total", style: TextStyle(color: colors.onSecondary.withOpacity(0.8))),
          Text(
            "R\$ ${balance.toStringAsFixed(2)}",
            style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: colors.onSecondary),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMiniInfo(context, Icons.arrow_upward, "Entradas", "R\$ ${income.toStringAsFixed(0)}"),
              _buildMiniInfo(context, Icons.arrow_downward, "Saídas", "R\$ ${expense.toStringAsFixed(0)}"),
            ],
          )
        ],
      ),
    );
  }
  
  Widget _buildMiniInfo(BuildContext context, IconData icon, String label, String value) {
     final color = Theme.of(context).colorScheme.onSecondary;
     return Row(children: [
       Icon(icon, color: color, size: 16),
       const SizedBox(width: 4),
       Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
         Text(label, style: TextStyle(color: color.withOpacity(0.7), fontSize: 10)),
         Text(value, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
       ])
     ]);
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
      ],
    );
  }

  Widget _buildTransactionItem(BuildContext context, TransactionModel t) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: t.isIncome ? AppColors.success.withOpacity(0.1) : AppColors.error.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            t.isIncome ? Icons.arrow_upward : Icons.arrow_downward,
            color: t.isIncome ? AppColors.success : AppColors.error,
          ),
        ),
        title: Text(t.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(
          "${t.date.day}/${t.date.month} - ${t.date.hour}:${t.date.minute.toString().padLeft(2, '0')}",
          style: TextStyle(color: colors.onSurface.withOpacity(0.5)),
        ),
        trailing: Text(
          t.isIncome ? "+ R\$ ${t.amount.toStringAsFixed(2)}" : "- R\$ ${t.amount.toStringAsFixed(2)}",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: t.isIncome ? AppColors.success : colors.onSurface,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}