import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ledger_app/core/widgets/error_banner.dart';
import 'package:ledger_app/features/add-expense/presentation/providers/expense_form_provider.dart';
import 'package:ledger_app/features/add-expense/presentation/widgets/amount_input.dart';
import 'package:ledger_app/features/add-expense/presentation/widgets/category_dropdown.dart';
import 'package:ledger_app/features/add-expense/presentation/widgets/save_expense_button.dart';
import 'package:ledger_app/features/add-expense/presentation/widgets/shared_expense_section.dart';
import 'package:ledger_app/shared/widgets/generic-input/generic_input.dart';
import 'package:ledger_app/shared/widgets/generic-input/input_type.dart';

class AddExpenseScreen extends ConsumerWidget {
  const AddExpenseScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(expenseFormProvider);
    final notifier = ref.read(expenseFormProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Add Expense')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AmountInput(onChanged: notifier.setAmount),
          const SizedBox(height: 16),
          CategoryDropdown(
            value: state.category,
            onChanged: (v) => notifier.setCategory(v!),
          ),
          const SizedBox(height: 16),
          GenericInput(
            inputType: InputType.text,
            label: 'Note (optional)',
            prefixIcon: const Icon(Icons.notes_rounded),
            onChanged: notifier.setNote,
          ),
          const SizedBox(height: 20),
          SharedExpenseSection(
            isShared: state.isShared,
            splitType: state.splitType,
            members: state.members,
            onSharedChanged: notifier.setIsShared,
            onSplitTypeChanged: notifier.setSplitType,
            onMemberInputChanged: notifier.setMemberInput,
          ),
          if (state.error != null) ...[
            const SizedBox(height: 16),
            ErrorBanner(message: state.error!),
          ],
          const SizedBox(height: 24),
          SaveExpenseButton(onSave: notifier.save),
        ],
      ),
    );
  }
}

