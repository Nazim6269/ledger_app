import 'package:flutter/material.dart';
import '../database/app_database.dart';
import '../models/split_type.dart';

class MemberSplitInput extends StatelessWidget {
  final HouseholdMember member;
  final SplitType splitType;
  final ValueChanged<double> onChanged;

  const MemberSplitInput({
    super.key,
    required this.member,
    required this.splitType,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: TextField(
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          labelText:
              member.userName +
              (splitType == SplitType.percentage ? ' (%)' : ' (\$)'),
        ),
        onChanged: (v) => onChanged(double.tryParse(v) ?? 0),
      ),
    );
  }
}
