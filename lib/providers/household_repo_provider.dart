import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ledger_app/providers/supabase_provider.dart';
import 'package:ledger_app/repositories/household_repo.dart';

final householdRepoProvider = Provider<HouseholdRepo>((ref) {
  return HouseholdRepo(ref.watch(supabaseProvider));
});

final currentHouseholdProvider = FutureProvider.autoDispose<HouseholdData?>((
  ref,
) {
  return ref.watch(householdRepoProvider).getMyHousehold();
});
