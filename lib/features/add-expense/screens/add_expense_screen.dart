import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ledger_app/widgets/member_splite_input.dart';
import 'package:ledger_app/widgets/splite_type_selector.dart';
import 'package:ledger_app/features/add-expense/domain/entities/split_type.dart';
import 'package:ledger_app/features/add-expense/presentation/providers/expense_form_provider.dart';

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
          TextField(
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Amount',
              prefixText: '\$ ',
            ),
            onChanged: (v) => notifier.setAmount(double.tryParse(v) ?? 0),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: state.category,
            items: [
              'Groceries',
              'Rent',
              'Utilities',
              'Dining',
              'Transport',
              'Other',
            ].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
            onChanged: (v) => notifier.setCategory(v!),
            decoration: const InputDecoration(labelText: 'Category'),
          ),
          const SizedBox(height: 12),
          TextField(
            decoration: const InputDecoration(labelText: 'Note (optional)'),
            onChanged: notifier.setNote,
          ),
          const SizedBox(height: 20),
          SwitchListTile(
            title: const Text('Shared expense'),
            value: state.isShared,
            onChanged: notifier.setIsShared,
          ),
          if (state.isShared) ...[
            SpliteTypeSelector(
              selected: state.splitType,
              onChanged: notifier.setSplitType,
            ),
            const SizedBox(height: 12),
            if (state.splitType != SplitType.equal)
              ...state.members.map(
                (m) => MemberSplitInput(
                  member: m,
                  splitType: state.splitType,
                  onChanged: (value) =>
                      notifier.setMemberInput(m.userId, value),
                ),
              ),
          ],
          if (state.error != null) ...[
            const SizedBox(height: 12),
            Text(
              state.error!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ],
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () async {
              final success = await notifier.save();
              if (success && context.mounted) Navigator.pop(context);
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Text('Save Expense'),
            ),
          ),
        ],
      ),
    );
  }
}
