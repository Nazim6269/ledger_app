import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ledger_app/providers/auth_provider.dart';
import 'package:ledger_app/providers/household_repo_provider.dart';
import 'package:ledger_app/providers/transaction_stream_provider.dart';
import 'package:ledger_app/screens/add_expense_screen.dart';
import 'package:ledger_app/screens/settlement_screen.dart';
import 'package:ledger_app/widgets/transaction_tile.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext ctx) {
    final transactionsAsync = ref.watch(transactionsStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ledger'),
        actions: [
          IconButton(
            onPressed: () {
              final household = ref.read(currentHouseholdProvider).value;
              if (household != null) {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text("Invite Code"),
                    content: SelectableText(household.id),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Close"),
                      ),
                    ],
                  ),
                );
              }
            },
            icon: Icon(Icons.group_add),
          ),
          IconButton(
            onPressed: () => Navigator.push(
              ctx,
              MaterialPageRoute(builder: (_) => const SettlementScreen()),
            ),
            icon: Icon(Icons.balance),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authrepoProvider).signOut(),
          ),
        ],
      ),
      body: transactionsAsync.when(
        data: (transactions) {
          if (transactions.isEmpty) {
            return const Center(
              child: Text('No expenses yet. Tap + to add one.'),
            );
          }
          return ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (context, index) =>
                TransactionTile(transaction: transactions[index]),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddExpenseScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
