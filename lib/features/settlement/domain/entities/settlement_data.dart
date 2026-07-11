import 'package:ledger_app/database/app_database.dart';

class SettlementData {
  final List<Transaction> sharedTransactions;
  final List<Split> allSplits;
  final List<Settlement> settlements;

  SettlementData(this.sharedTransactions, this.allSplits, this.settlements);

  Map<String, List<Split>> get splitsByTransactionId {
    final map = <String, List<Split>>{};
    for (final s in allSplits) {
      map.putIfAbsent(s.transactionId, () => []).add(s);
    }
    return map;
  }
}
