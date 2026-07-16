import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ledger_app/features/common/providers/supabase_provider.dart';

final currentUserProvider = Provider<String>((ref) {
  final client = ref.watch(supabaseProvider);
  final user = client.auth.currentUser;
  if (user == null) throw Exception('No authenticated user');
  return user.id;
});
