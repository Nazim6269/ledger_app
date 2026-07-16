import 'package:flutter/material.dart';
import 'package:ledger_app/shared/widgets/generic-input/generic_input.dart';
import 'package:ledger_app/shared/widgets/generic-input/input_type.dart';

class AmountInput extends StatelessWidget {
  const AmountInput({super.key, required this.onChanged});

  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return GenericInput(
      inputType: InputType.number,
      label: 'Amount',
      prefix: const Text('\$ '),
      style: Theme.of(context).textTheme.headlineSmall,
      onChanged: (v) => onChanged(double.tryParse(v) ?? 0),
    );
  }
}
