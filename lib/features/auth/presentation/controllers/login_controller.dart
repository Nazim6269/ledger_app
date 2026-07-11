import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ledger_app/features/auth/domain/entities/user_entity.dart';
import 'package:ledger_app/features/auth/presentation/providers/auth_provider.dart';

class LoginController extends AsyncNotifier<UserEntity?> {
  @override
  Future<UserEntity?> build() async => null;

  Future<void> login({required String email, required String password}) async {
    state = const AsyncLoading();

    final result = await ref
        .read(authRepositoryProvider)
        .signIn(email: email.trim(), password: password.trim());

    state = result.when(
      failure: (f) => AsyncError(f, StackTrace.current),
      success: (user) => AsyncData(user),
    );
  }
}

final loginControllerProvider =
    AsyncNotifierProvider<LoginController, UserEntity?>(LoginController.new);
