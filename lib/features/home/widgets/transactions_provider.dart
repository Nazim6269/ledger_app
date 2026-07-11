import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ledger_app/database/app_database.dart';
import 'package:ledger_app/features/household/presentation/providers/household_provider.dart';
import 'package:ledger_app/features/common/providers/database_provider.dart';

final transactionsStreamProvider =
    StreamProvider.autoDispose<List<Transaction>>((ref) {
      final householdId = ref.watch(currentHouseholdProvider).value;
      if (householdId == null) return const Stream.empty();
      return ref.watch(databaseProvider).watchTransactions(householdId.id);
    });
