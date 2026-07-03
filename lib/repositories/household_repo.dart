import 'package:supabase_flutter/supabase_flutter.dart';

class HouseholdData {
  final String id;
  final String name;
  HouseholdData({required this.id, required this.name});
}

class HouseholdRepo {
  final SupabaseClient _client;
  HouseholdRepo(this._client);

  Future<HouseholdData?> getMyHousehold() async {
    final userId = _client.auth.currentUser!.id;

    final memberShip = await _client
        .from("household_members")
        .select('household_id, households(id, name)')
        .eq('user_id', userId)
        .maybeSingle();

    if (memberShip == null) return null;

    final household = memberShip['households'];
    return HouseholdData(id: household['id'], name: household['name']);
  }

  Future<HouseholdData> createHouseHold(String name) async {
    final userId = _client.auth.currentUser!.id;
    final userName =
        _client.auth.currentUser!.userMetadata?['name'] ?? 'Member';

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

    return HouseholdData(id: householdId, name: name);
  }

  Future<HouseholdData> joinHousehold(String householdId) async {
    final userId = _client.auth.currentUser!.id;
    final userName =
        _client.auth.currentUser!.userMetadata?['name'] ?? 'Member';

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

    return HouseholdData(id: household['id'], name: household['name']);
  }
}
