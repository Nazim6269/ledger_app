import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ledger_app/features/auth/presentation/providers/auth_provider.dart';

class ForgotPasswordController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> sendResetEmail(String email) async {
    state = const AsyncLoading<void>();
    final result = await ref
        .read(authRepositoryProvider)
        .sendResetPasswordEmail(email);
    state = result.when<AsyncValue<void>>(
      failure: (f) => AsyncError<void>(f, StackTrace.current),
      success: (_) => const AsyncData<void>(null),
    );
  }
}

final forgotPasswordControllerProvider =
    AsyncNotifierProvider<ForgotPasswordController, void>(
      ForgotPasswordController.new,
    );
