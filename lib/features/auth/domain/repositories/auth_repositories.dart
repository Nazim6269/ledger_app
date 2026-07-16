import 'package:ledger_app/features/auth/domain/entities/user_entity.dart';
import 'package:ledger_app/features/auth/domain/failure/auth_failure.dart';
import 'package:ledger_app/core/utils/result.dart';

abstract class AuthRepository {
  Future<Result<AuthFailure, UserEntity>> signIn({
    required String email,
    required String password,
  });

  Future<Result<AuthFailure, UserEntity>> signUp({
    required String email,
    required String password,
    required String name,
  });

  Future<Result<AuthFailure, void>> sendResetPasswordEmail(String email);
  Future<Result<AuthFailure, void>> updatePassword(String password);
  Future<void> signOut();
}
