import 'package:flutter/material.dart';
import 'package:planejamento_financeiro/core/theme/app_colors.dart';
import 'package:planejamento_financeiro/data/models/wishlist_item_model.dart';
import 'package:planejamento_financeiro/data/services/wishlist_service.dart';

class WishlistPage extends StatelessWidget {
  const WishlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final service = WishlistService();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Meus Objetivos"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddWishDialog(context, service),
          ),
        ],
      ),
      body: StreamBuilder<List<WishlistItemModel>>(
        stream: service.getWishlistStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                "Nenhum sonho cadastrado ainda.\nClique no + para adicionar.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: theme.colorScheme.onSurface.withOpacity(0.5),
                ),
              ),
            );
          }

          final items = snapshot.data!;

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // Mantive o card estático de meta mensal por enquanto
              _buildMonthlyGoalCard(theme),
              const SizedBox(height: 24),
              Text("Lista de Desejos", style: theme.textTheme.titleLarge),
              const SizedBox(height: 16),

              ...items.map((item) => _buildWishItem(context, item, service)),
            ],
          );
        },
      ),
    );
  }

  // Dialog simples para adicionar sonho
  void _showAddWishDialog(BuildContext context, WishlistService service) {
    final titleController = TextEditingController();
    final priceController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Novo Sonho"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: "Nome do Item"),
            ),
            TextField(
              controller: priceController,
              decoration: const InputDecoration(labelText: "Valor (R\$)"),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancelar"),
          ),
          FilledButton(
            onPressed: () {
              final item = WishlistItemModel(
                id: '',
                title: titleController.text,
                price: double.tryParse(priceController.text) ?? 0,
                savedAmount: 0,
              );
              service.addItem(item);
              Navigator.pop(ctx);
            },
            child: const Text("Salvar"),
          ),
        ],
      ),
    );
  }

  Widget _buildWishItem(
    BuildContext context,
    WishlistItemModel item,
    WishlistService service,
  ) {
    final theme = Theme.of(context);
    final percent = (item.savedAmount / item.price).clamp(0.0, 1.0);
    final color = item.isCompleted ? AppColors.success : AppColors.greenTeal;

    return Dismissible(
      key: Key(item.id),
      background: Container(
        color: AppColors.error,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => service.deleteItem(item.id),
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
        child: InkWell(
          onTap: () {
            // Ao clicar, simulamos que a pessoa guardou dinheiro (exemplo simples)
            // Futuramente podemos abrir uma tela de detalhes
            if (!item.isCompleted) {
              final newSaved =
                  item.savedAmount + (item.price * 0.1); // Adiciona 10%
              final isNowCompleted = newSaved >= item.price;
              service.updateItem(
                WishlistItemModel(
                  id: item.id,
                  title: item.title,
                  price: item.price,
                  savedAmount: isNowCompleted ? item.price : newSaved,
                  isCompleted: isNowCompleted,
                ),
              );
            }
          },
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
                        item.isCompleted ? Icons.check_circle : Icons.star,
                        color: color,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            item.isCompleted
                                ? "Conquistado!"
                                : "R\$ ${item.savedAmount.toStringAsFixed(0)} / R\$ ${item.price.toStringAsFixed(0)}",
                            style: TextStyle(
                              color: theme.colorScheme.onSurface.withOpacity(
                                0.6,
                              ),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      "${(percent * 100).toInt()}%",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: percent,
                    minHeight: 8,
                    backgroundColor: theme.colorScheme.surface,
                    valueColor: AlwaysStoppedAnimation(color),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMonthlyGoalCard(ThemeData theme) {
    return Container(
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
                Text(
                  "R\$ 500,00",
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
