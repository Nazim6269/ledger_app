import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ledger_app/providers/household_repo_provider.dart';
import 'package:ledger_app/providers/repo_provider.dart';
import 'package:ledger_app/repositories/transaction_repo.dart';

final settlementProvider = StreamProvider.autoDispose<SettlementData>((ref) {
  final householdId = ref.watch(currentHouseholdProvider).value;
  if (householdId == null) return Stream.empty();
  return ref.watch(transactionRepoProvider).watchSettlemenData(householdId.id);
});
