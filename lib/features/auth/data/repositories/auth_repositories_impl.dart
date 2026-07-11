import 'package:ledger_app/features/auth/data/datasource/auth_remote_ds.dart';
import 'package:ledger_app/features/auth/domain/entities/user_entity.dart';
import 'package:ledger_app/features/auth/domain/failure/auth_failure.dart';
import 'package:ledger_app/features/auth/domain/repositories/auth_repositories.dart';
import 'package:ledger_app/utils/result.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._remoteDataSource);
  final AuthRemoteDataSource _remoteDataSource;

  @override
  Future<Result<AuthFailure, UserEntity>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final user = await _remoteDataSource.signIn(
        email: email,
        password: password,
      );
      return Succeeded(UserEntity(id: user.id, email: user.email ?? email));
    } on AuthException catch (e) {
      return Failed(_mapSupabaseError(e));
    } catch (_) {
      return const Failed(UnknownAuthFailure());
    }
  }

  @override
  Future<void> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      await _remoteDataSource.signUp(
        email: email,
        password: password,
        name: name,
      );
    } on AuthException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<void> signOut() async {
    await _remoteDataSource.signOut();
  }

  AuthFailure _mapSupabaseError(AuthException e) {
    // Supabase doesn't give granular error codes the way Firebase does —
    // it mostly returns generic messages, so matching on message text
    // is the practical approach here.
    final msg = e.message.toLowerCase();

    if (msg.contains('invalid login credentials')) {
      return const InvalidCredentialsFailure();
    }
    if (msg.contains('email not confirmed')) {
      return const UnknownAuthFailure(
        'Please confirm your email before logging in.',
      );
    }
    if (e.statusCode == '0' || msg.contains('network')) {
      return const NetworkFailure();
    }
    return UnknownAuthFailure(e.message);
  }
}
