import 'package:ledger_app/features/household/domain/entities/household.dart';
import 'package:ledger_app/features/household/domain/repositories/household_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HouseholdRepositoryImpl implements HouseholdRepository {
  final SupabaseClient _client;
  HouseholdRepositoryImpl(this._client);

  User _requireUser() {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('Not authenticated');
    return user;
  }

  @override
  Future<Household?> getMyHousehold() async {
    final userId = _requireUser().id;

    final memberShip = await _client
        .from("household_members")
        .select('household_id, households(id, name)')
        .eq('user_id', userId)
        .maybeSingle();

    if (memberShip == null) return null;

    final household = memberShip['households'];
    return Household(id: household['id'], name: household['name']);
  }

  @override
  Future<Household> createHousehold(String name) async {
    final user = _requireUser();
    final userId = user.id;
    final userName = user.userMetadata?['name'] ?? 'Member';

    final inserted = await _client
        .from('households')
        .insert({'name': name, 'created_by': userId})
        .select()
        .single();

    final householdId = inserted['id'];

    await _client.from('household_members').insert({
      'household_id': householdId,
      'user_id': userId,
      'user_name': userName,
    });

    return Household(id: householdId, name: name);
  }

  @override
  Future<Household> joinHousehold(String householdId) async {
    final user = _requireUser();
    final userId = user.id;
    final userName = user.userMetadata?['name'] ?? 'Member';

    final household = await _client
        .from('households')
        .select()
        .eq('id', householdId)
        .single();
    await _client.from('household_members').insert({
      'household_id': householdId,
      'user_id': userId,
      'user_name': userName,
    });

    return Household(id: household['id'], name: household['name']);
  }
}
