import 'package:flutter/material.dart';
import 'package:ledger_app/core/widgets/app_dropdown.dart';

const kExpenseCategories = [
  'Groceries',
  'Rent',
  'Utilities',
  'Dining',
  'Transport',
  'Other',
];

class CategoryDropdown extends StatelessWidget {
  const CategoryDropdown({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final String? value;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return AppDropdown<String>(
      value: value,
      items: kExpenseCategories,
      itemLabel: (c) => c,
      onChanged: onChanged,
      label: 'Category',
      prefixIcon: const Icon(Icons.category_outlined),
    );
  }
}
