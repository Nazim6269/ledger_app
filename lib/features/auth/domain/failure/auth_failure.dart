import 'package:ledger_app/core/error/failure.dart';

sealed class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

class InvalidCredentialsFailure extends AuthFailure {
  const InvalidCredentialsFailure()
      : super('Incorrect email or password. If you just signed up, confirm your email first.');
}

class UserNotFoundFailure extends AuthFailure {
  const UserNotFoundFailure() : super('No account found with this email.');
}

class NetworkFailure extends AuthFailure {
  const NetworkFailure()
    : super('Check your internet connection and try again.');
}

class EmailConfirmationRequired extends AuthFailure {
  const EmailConfirmationRequired()
      : super('Please check your inbox to confirm your email before logging in.');
}

class PasswordResetFailure extends AuthFailure {
  const PasswordResetFailure([super.message = 'Failed to reset password. Try again.']);
}

class UnknownAuthFailure extends AuthFailure {
  const UnknownAuthFailure([
    super.message = 'Something went wrong. Please try again.',
  ]);
}
