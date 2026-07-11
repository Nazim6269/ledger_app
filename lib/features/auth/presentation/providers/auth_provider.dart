import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ledger_app/features/auth/data/datasource/auth_remote_ds.dart';
import 'package:ledger_app/features/auth/data/repositories/auth_repositories_impl.dart';
import 'package:ledger_app/features/auth/domain/repositories/auth_repositories.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabaseClientProvider = Provider<SupabaseClient>(
  (ref) => Supabase.instance.client,
);

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>(
  (ref) => AuthRemoteDataSource(ref.watch(supabaseClientProvider)),
);

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepositoryImpl(ref.watch(authRemoteDataSourceProvider)),
);

final authStateProvider = StreamProvider<AuthState>(
  (ref) => ref.watch(supabaseClientProvider).auth.onAuthStateChange,
);

