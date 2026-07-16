import 'package:flutter/material.dart';
import 'package:ledger_app/shared/widgets/generic-button/generic_button.dart';

class SaveExpenseButton extends StatelessWidget {
  const SaveExpenseButton({
    super.key,
    required this.onSave,
    this.isLoading = false,
  });

  final Future<bool> Function() onSave;
  final bool isLoading;

  Future<void> _handleTap(BuildContext context) async {
    final success = await onSave();
    if (success && context.mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: GenericButton(
        label: 'Save Expense',
        isLoading: isLoading,
        onPressed: () => _handleTap(context),
      ),
    );
  }
}
