import 'package:flutter/material.dart';
import 'package:ledger_app/features/add-expense/screens/add_expense_screen.dart';

class AddExpenseFab extends StatelessWidget {
  const AddExpenseFab({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddExpenseScreen()),
        );
      },
    );
  }
}
