import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ledger_app/features/common/providers/database_provider.dart';
import 'package:ledger_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:ledger_app/features/household/presentation/providers/household_provider.dart';
import 'package:ledger_app/features/settlement/data/repositories/settlement_repository_impl.dart';
import 'package:ledger_app/features/settlement/domain/entities/settlement_data.dart';
import 'package:ledger_app/features/settlement/domain/repositories/settlement_repository.dart';

final settlementRepoProvider = Provider<SettlementRepository>((ref) {
  return SettlementRepositoryImpl(
    ref.watch(databaseProvider),
    ref.watch(supabaseClientProvider),
  );
});

final settlementProvider = StreamProvider.autoDispose<SettlementData>((ref) {
  final householdId = ref.watch(currentHouseholdProvider).value;
  if (householdId == null) return Stream.empty();
  return ref.watch(settlementRepoProvider).watchSettlementData(householdId.id);
});
