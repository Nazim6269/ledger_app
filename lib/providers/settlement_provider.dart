import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ledger_app/providers/repo_provider.dart';
import 'package:ledger_app/repositories/transaction_repo.dart';
import 'transaction_stream_provider.dart';

final settlementProvider = StreamProvider.autoDispose<SettlementData>((ref) {
  return ref.watch(transactionRepoProvider).watchSettlemenData(householdId);
});
