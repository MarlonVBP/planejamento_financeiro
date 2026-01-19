import 'package:flutter/material.dart';
import 'package:planejamento_financeiro/core/theme/app_colors.dart';
import 'package:planejamento_financeiro/data/models/transaction_model.dart';
import 'package:planejamento_financeiro/data/services/transaction_service.dart';

class TransactionFormPage extends StatefulWidget {
  const TransactionFormPage({super.key});

  @override
  State<TransactionFormPage> createState() => _TransactionFormPageState();
}

class _TransactionFormPageState extends State<TransactionFormPage> {
  bool _isIncome = false;
  final _amountController = TextEditingController();
  final _descController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  final _service = TransactionService(); // Instância do Serviço
  bool _isLoading = false;

  Future<void> _saveTransaction() async {
    if (_amountController.text.isEmpty || _descController.text.isEmpty) return;

    setState(() => _isLoading = true);

    final double amount =
        double.tryParse(_amountController.text.replaceAll(',', '.')) ?? 0.0;

    final transaction = TransactionModel(
      id: '', // O Firebase gera o ID
      title: _descController.text,
      amount: amount,
      isIncome: _isIncome,
      date: _selectedDate,
    );

    try {
      await _service.addTransaction(transaction);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erro ao salvar: $e"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeColor = _isIncome ? AppColors.success : AppColors.error;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(_isIncome ? "Nova Receita" : "Nova Despesa"),
      ),
      body: Column(
        children: [
          // Header com Valor Gigante
          Container(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Valor",
                  style: TextStyle(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
                TextField(
                  controller: _amountController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: activeColor,
                  ),
                  decoration: InputDecoration(
                    prefixText: "R\$ ",
                    border: InputBorder.none,
                    hintText: "0,00",
                    hintStyle: TextStyle(
                      color: theme.colorScheme.onSurface.withOpacity(0.2),
                    ),
                  ),
                  autofocus: true,
                ),
              ],
            ),
          ),

          Expanded(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainer,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(32),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Seletor de Tipo (Receita / Despesa)
                    SegmentedButton<bool>(
                      segments: const [
                        ButtonSegment(
                          value: false,
                          label: Text("Despesa"),
                          icon: Icon(Icons.arrow_downward),
                        ),
                        ButtonSegment(
                          value: true,
                          label: Text("Receita"),
                          icon: Icon(Icons.arrow_upward),
                        ),
                      ],
                      selected: {_isIncome},
                      onSelectionChanged: (Set<bool> newSelection) {
                        setState(() {
                          _isIncome = newSelection.first;
                        });
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color?>((states) {
                              if (states.contains(MaterialState.selected)) {
                                return activeColor.withOpacity(0.2);
                              }
                              return null;
                            }),
                        foregroundColor: MaterialStateProperty.resolveWith<Color?>((
                          states,
                        ) {
                          if (states.contains(MaterialState.selected)) {
                            return activeColor; // Ícone/Texto colorido quando selecionado
                          }
                          return theme.colorScheme.onSurface;
                        }),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Inputs Padrão
                    TextField(
                      controller: _descController,
                      decoration: const InputDecoration(
                        labelText: "Descrição",
                        prefixIcon: Icon(Icons.description_outlined),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Input de Data (Fake por enquanto)
                    InkWell(
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2030),
                        );
                        if (date != null) setState(() => _selectedDate = date);
                      },
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: "Data",
                          prefixIcon: Icon(Icons.calendar_today),
                          border: OutlineInputBorder(),
                        ),
                        child: Text(
                          "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}",
                          style: TextStyle(color: theme.colorScheme.onSurface),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Botão Salvar
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () {
                          // Lógica de salvar virá depois
                          Navigator.pop(context);
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: activeColor,
                        ),
                        child: const Text("Confirmar"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
