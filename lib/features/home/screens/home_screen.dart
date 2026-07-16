import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ledger_app/features/add-expense/presentation/providers/expense_provider.dart';
import 'package:ledger_app/features/add-expense/presentation/screens/add_expense_screen.dart';
import 'package:ledger_app/features/home/widgets/home_bar_actions.dart';
import 'package:ledger_app/features/home/widgets/transaction_list.dart';
import 'package:ledger_app/features/home/widgets/transactions_provider.dart';
import 'package:ledger_app/features/household/presentation/providers/household_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  Timer? _syncTimer;

  @override
  void initState() {
    super.initState();
    Future.microtask(_startSync);
    _syncTimer = Timer.periodic(const Duration(seconds: 15), (_) {
      ref.read(transactionRepositoryProvider).processOutbox();
    });
  }

  void _startSync() {
    final household = ref.read(currentHouseholdProvider).value;
    final repo = ref.read(transactionRepositoryProvider);
    if (household != null) {
      repo.startRealtimeSync(household.id);
    }
    repo.processOutbox();
  }

  @override
  void dispose() {
    _syncTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final transactionsAsync = ref.watch(transactionsStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ledger'),
        centerTitle: false,
        actions: const [HomeAppBarActions(), SizedBox(width: 4)],
      ),
      body: transactionsAsync.when(
        data: (transactions) => TransactionList(transactions: transactions),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddExpenseScreen()),
        ),
        icon: const Icon(Icons.add),
        label: const Text('Add Expense'),
      ),
    );
  }
}
