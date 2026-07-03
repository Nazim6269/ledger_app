import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ledger_app/providers/household_repo_provider.dart';
import 'package:ledger_app/providers/repo_provider.dart';
import '../database/app_database.dart';

final transactionsStreamProvider =
    StreamProvider.autoDispose<List<Transaction>>((ref) {
      final householdId = ref.watch(currentHouseholdProvider).value;
      if (householdId == null) return const Stream.empty();
      return ref
          .watch(transactionRepoProvider)
          .watchTransactions(householdId.id);
    });
