import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ledger_app/database/app_database.dart';
import 'package:ledger_app/features/common/empty_view_widget.dart';
import 'package:ledger_app/features/common/loading_widget.dart';
import 'package:ledger_app/widgets/transaction_tile.dart';

class TransactionList extends StatelessWidget {
  final AsyncValue<List<Transaction>> transactions;

  const TransactionList({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    return transactions.when(
      loading: () => const LoadingWidget(),

      error: (e, s) => ErrorWidget(e),

      data: (items) {
        if (items.isEmpty) {
          return const EmptyViewWidget();
        }

        return ListView.builder(
          itemCount: items.length,
          itemBuilder: (_, index) {
            return TransactionTile(transaction: items[index]);
          },
        );
      },
    );
  }
}
