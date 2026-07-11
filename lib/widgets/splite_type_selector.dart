import 'package:flutter/material.dart';
import 'package:ledger_app/features/add-expense/domain/entities/split_type.dart';

class SpliteTypeSelector extends StatelessWidget {
  final SplitType selected;
  final ValueChanged<SplitType> onChanged;

  const SpliteTypeSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext ctx) {
    return SegmentedButton<SplitType>(
      segments: const [
        ButtonSegment(value: SplitType.equal, label: const Text('Equal')),
        ButtonSegment(value: SplitType.percentage, label: const Text("%")),
        ButtonSegment(value: SplitType.exact, label: const Text("Exact")),
      ],
      selected: {selected},
      onSelectionChanged: (s) => onChanged(s.first),
    );
  }
}
