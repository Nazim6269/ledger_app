import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ledger_app/features/household/presentation/providers/household_provider.dart';
import 'package:ledger_app/features/settlement/domain/services/settlement_calculator.dart';
import 'package:ledger_app/features/settlement/presentation/providers/settlement_provider.dart';
import 'package:ledger_app/features/common/providers/current_user_provider.dart';

class SettlementScreen extends ConsumerWidget {
  const SettlementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataAsync = ref.watch(settlementProvider);
    final currentUserId = ref.watch(currentUserProvider);

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
                title: Text(userId == currentUserId ? 'You' : userId),
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
                    : () => _confirmSettle(
                        context,
                        ref,
                        currentUserId,
                        userId,
                        balance,
                      ),
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
    String currentUserId,
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
              final household = ref.read(currentHouseholdProvider).value;
              if (household == null) return;
              await ref
                  .read(settlementRepoProvider)
                  .settleUp(
                    householdId: household.id,
                    fromUserId: isOwedByMe ? currentUserId : otherUserId,
                    toUserId: isOwedByMe ? otherUserId : currentUserId,
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
