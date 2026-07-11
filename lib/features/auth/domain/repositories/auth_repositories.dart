import 'package:ledger_app/features/auth/domain/entities/user_entity.dart';
import 'package:ledger_app/features/auth/domain/failure/auth_failure.dart';
import 'package:ledger_app/utils/result.dart';

abstract class AuthRepository {
  Future<Result<AuthFailure, UserEntity>> signIn({
    required String email,
    required String password,
  });

  Future<void> signUp({
    required String email,
    required String password,
    required String name,
  });

  Future<void> signOut();
}
