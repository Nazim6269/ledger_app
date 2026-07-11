import 'package:ledger_app/core/error/failure.dart';

sealed class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

class InvalidCredentialsFailure extends AuthFailure {
  const InvalidCredentialsFailure() : super('Incorrect email or password.');
}

class UserNotFoundFailure extends AuthFailure {
  const UserNotFoundFailure() : super('No account found with this email.');
}

class NetworkFailure extends AuthFailure {
  const NetworkFailure()
    : super('Check your internet connection and try again.');
}

class UnknownAuthFailure extends AuthFailure {
  const UnknownAuthFailure([
    super.message = 'Something went wrong. Please try again.',
  ]);
}
