import 'package:flutter/material.dart';
import 'package:ledger_app/core/widgets/empty_state.dart';
import 'package:ledger_app/widgets/transaction_tile.dart';

class TransactionList extends StatelessWidget {
  const TransactionList({
    super.key,
    required this.transactions,
    this.textColor,
  });

  final List<dynamic>
  transactions; // swap `dynamic` for your Transaction entity type
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return EmptyState(
        icon: Icons.receipt_long_rounded,
        title: 'No expenses yet',
        subtitle: 'Tap the + button below to add your first one.',
        color: textColor,
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 96),
      itemCount: transactions.length,
      itemBuilder: (context, index) => TransactionTile(
        transaction: transactions[index],
        textColor: textColor,
      ),
    );
  }
}
