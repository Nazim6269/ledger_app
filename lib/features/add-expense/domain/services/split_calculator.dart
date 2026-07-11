import 'package:ledger_app/features/add-expense/domain/entities/member_input.dart';
import 'package:ledger_app/features/add-expense/domain/entities/split_result.dart';
import 'package:ledger_app/features/add-expense/domain/entities/split_type.dart';

class SplitCalculator {
  static SplitResult calculate({
    required SplitType type,
    required double totalAmount,
    required List<MemberInput> members,
  }) {
    switch (type) {
      case SplitType.equal:
        final share = totalAmount / members.length;
        return SplitResult.success({for (final m in members) m.userId: share});

      case SplitType.exact:
        final sum = members.fold<double>(0, (s, m) => s + m.rawValue);
        if ((sum - totalAmount).abs() > 0.01) {
          return SplitResult.failure(
            'Split Total $sum  but expense is $totalAmount',
          );
        }

        return SplitResult.success({
          for (final m in members) m.userId: m.rawValue,
        });

      case SplitType.percentage:
        final sumPct = members.fold<double>(0, (s, m) => s + m.rawValue);
        if ((sumPct - 100).abs() > 0.01) {
          return SplitResult.failure('Percentage total $sumPct , must be 100');
        }
        return SplitResult.success({
          for (final m in members) m.userId: totalAmount * (m.rawValue / 100),
        });
    }
  }
}
