import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ledger_app/providers/database_provider.dart';
import 'package:ledger_app/repositories/transaction_repo.dart';

final transactionRepoProvider = Provider<TransactionRepository>((ref) {
  return TransactionRepository(ref.watch(databaseProvider));
});
