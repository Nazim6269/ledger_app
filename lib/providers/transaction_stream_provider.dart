import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ledger_app/providers/repo_provider.dart';
import '../database/app_database.dart';

const householdId = 'house_1';

final transactionsStreamProvider =
    StreamProvider.autoDispose<List<Transaction>>((ref) {
      return ref.watch(transactionRepoProvider).watchTransactions(householdId);
    });
