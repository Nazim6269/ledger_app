import 'package:flutter/material.dart';
import 'package:ledger_app/features/add-expense/domain/entities/split_type.dart';
import 'package:ledger_app/widgets/member_splite_input.dart';
import 'package:ledger_app/widgets/splite_type_selector.dart';

class SharedExpenseSection extends StatelessWidget {
  const SharedExpenseSection({
    super.key,
    required this.isShared,
    required this.splitType,
    required this.members,
    required this.onSharedChanged,
    required this.onSplitTypeChanged,
    required this.onMemberInputChanged,
  });

  final bool isShared;
  final SplitType splitType;
  final List<dynamic> members; // swap for your Member entity type
  final ValueChanged<bool> onSharedChanged;
  final ValueChanged<SplitType> onSplitTypeChanged;
  final void Function(String userId, double value) onMemberInputChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          SwitchListTile(
            title: const Text('Shared expense'),
            subtitle: const Text('Split this with household members'),
            value: isShared,
            onChanged: onSharedChanged,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
          if (isShared)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                children: [
                  SpliteTypeSelector(
                    selected: splitType,
                    onChanged: onSplitTypeChanged,
                  ),
                  if (splitType != SplitType.equal) ...[
                    const SizedBox(height: 12),
                    ...members.map(
                      (m) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: MemberSplitInput(
                          member: m,
                          splitType: splitType,
                          onChanged: (value) =>
                              onMemberInputChanged(m.userId, value),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }
}
