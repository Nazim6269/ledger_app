import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../database/app_database.dart';

class TransactionTile extends StatelessWidget {
  final Transaction transaction;
  const TransactionTile({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('MMM d, h:mm a');

    return ListTile(
      leading: CircleAvatar(
        child: Icon(transaction.isShared ? Icons.people : Icons.person),
      ),
      title: Text(transaction.category),
      subtitle: Text(
        transaction.note.isNotEmpty
            ? '${transaction.note} · ${formatter.format(transaction.createdAt)}'
            : formatter.format(transaction.createdAt),
      ),
      trailing: Text(
        '\$${transaction.amount.toStringAsFixed(2)}',
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }
}

