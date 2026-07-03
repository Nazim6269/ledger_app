import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ledger_app/providers/repo_provider.dart';
import 'package:ledger_app/providers/transaction_stream_provider.dart';
import '../logic/settlement_calculator.dart';
import '../providers/settlement_provider.dart';

const _currentUserId = 'user_1'; // hardcoded until auth exists

class SettlementScreen extends ConsumerWidget {
  const SettlementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataAsync = ref.watch(settlementProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settle Up')),
      body: dataAsync.when(
        data: (data) {
          final balances = SettlementCalculator.calculateBalances(
            sharedTransactions: data.sharedTransactions,
            splitsByTransactionId: data.splitsByTransactionId,
            settlements: data.settlements,
          );

          if (balances.isEmpty ||
              balances.values.every((v) => v.abs() < 0.01)) {
            return const Center(child: Text('All settled up! 🎉'));
          }

          final entries = balances.entries.toList();

          return ListView.builder(
            itemCount: entries.length,
            itemBuilder: (context, index) {
              final userId = entries[index].key;
              final balance = entries[index].value;
              final isOwed = balance > 0;

              return ListTile(
                leading: Icon(
                  isOwed ? Icons.arrow_downward : Icons.arrow_upward,
                  color: isOwed ? Colors.green : Colors.red,
                ),
                title: Text(userId == _currentUserId ? 'You' : userId),
                subtitle: Text(isOwed ? 'is owed' : 'owes'),
                trailing: Text(
                  '\$${balance.abs().toStringAsFixed(2)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isOwed ? Colors.green : Colors.red,
                  ),
                ),
                onTap: balance.abs() < 0.01
                    ? null
                    : () => _confirmSettle(context, ref, userId, balance),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }

  void _confirmSettle(
    BuildContext context,
    WidgetRef ref,
    String otherUserId,
    double balance,
  ) {
    final isOwedByMe = balance < 0; // I owe them
    final amount = balance.abs();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Settle Up'),
        content: Text(
          isOwedByMe
              ? 'Mark that you paid $otherUserId \$${amount.toStringAsFixed(2)}?'
              : 'Mark that $otherUserId paid you \$${amount.toStringAsFixed(2)}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              await ref
                  .read(transactionRepoProvider)
                  .settleUp(
                    householdId: householdId,
                    fromUserId: isOwedByMe ? _currentUserId : otherUserId,
                    toUserId: isOwedByMe ? otherUserId : _currentUserId,
                    amount: amount,
                  );
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }
}
