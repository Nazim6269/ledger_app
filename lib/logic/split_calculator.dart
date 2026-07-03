import 'package:ledger_app/models/split_type.dart';

class MemberInput {
  final String userId;
  final String userName;
  final double rawValue;

  MemberInput({
    required this.userId,
    required this.userName,
    this.rawValue = 0,
  });
}

class SplitResult {
  final Map<String, double> amountByUserId;
  final String? error;

  SplitResult.success(this.amountByUserId) : error = null;
  SplitResult.failure(this.error) : amountByUserId = const {};

  bool get isValid => error == null;
}

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
