import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ledger_app/features/household/data/repositories/household_repository_impl.dart';
import 'package:ledger_app/features/household/domain/entities/household.dart';
import 'package:ledger_app/features/household/domain/repositories/household_repository.dart';
import 'package:ledger_app/features/common/providers/supabase_provider.dart';

final householdRepoProvider = Provider<HouseholdRepository>((ref) {
  return HouseholdRepositoryImpl(ref.watch(supabaseProvider));
});

final currentHouseholdProvider = FutureProvider.autoDispose<Household?>((ref) {
  return ref.watch(householdRepoProvider).getMyHousehold();
});
