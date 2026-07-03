import 'package:ledger_app/database/app_database.dart';

class SettlementCalculator {
  static Map<String, double> calculateBalances({
    required List<Transaction> sharedTransactions,
    required Map<String, List<Split>> splitsByTransactionId,
    required List<Settlement> settlements,
  }) {
    final balances = <String, double>{};

    for (final t in sharedTransactions) {
      final splits = splitsByTransactionId[t.id] ?? [];

      for (final s in splits) {
        if (s.userId == t.createdBy) continue;
        balances[s.userId] = (balances[s.userId] ?? 0) - s.amountOwed;
        balances[t.createdBy] = (balances[t.createdBy] ?? 0) + s.amountOwed;
      }
    }

    for (final settle in settlements) {
      balances[settle.fromUserId] =
          (balances[settle.fromUserId] ?? 0) + settle.amount;
      balances[settle.toUserId] =
          (balances[settle.toUserId] ?? 0) - settle.amount;
    }
    return balances;
  }
}
