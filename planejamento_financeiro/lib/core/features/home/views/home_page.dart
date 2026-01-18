import 'package:flutter/material.dart';
import '../../dashboard/views/dashboard_page.dart';
import '../../wishlist/views/wishlist_page.dart';
import '../../transactions/views/transaction_form_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const DashboardPage(),
    const WishlistPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      // Mantém o estado das páginas (não recarrega ao trocar de aba)
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        indicatorColor: theme.colorScheme.primary.withOpacity(0.2),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.grid_view_outlined),
            selectedIcon: Icon(Icons.grid_view_rounded),
            label: 'Visão Geral',
          ),
          NavigationDestination(
            icon: Icon(Icons.auto_awesome_outlined),
            selectedIcon: Icon(Icons.auto_awesome),
            label: 'Meus Sonhos',
          ),
        ],
      ),
      // Botão centralizado para adicionar transação rápida
      floatingActionButton: FloatingActionButton(
        onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const TransactionFormPage()),
            );
        },
        elevation: 2,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}