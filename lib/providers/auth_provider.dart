import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ledger_app/providers/supabase_provider.dart';
import 'package:ledger_app/repositories/auth_repo.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final authrepoProvider = Provider<AuthRepo>((ref) {
  return AuthRepo(ref.watch(supabaseProvider));
});

final authStateProvider = StreamProvider<AuthState>((ref) {
  return ref.watch(authrepoProvider).authStateChange;
});
