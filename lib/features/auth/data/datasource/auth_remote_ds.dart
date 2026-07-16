import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRemoteDataSource {
  AuthRemoteDataSource(this._supabase);
  final SupabaseClient _supabase;

  Future<User> signIn({required String email, required String password}) async {
    final response = await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
    final user = response.user;
    if (user == null) {
      throw const AuthException('No user returned');
    }
    return user;
  }

  Future<void> sendResetPasswordEmail(String email) async {
    await _supabase.auth.resetPasswordForEmail(email);
  }

  Future<void> updatePassword(String password) async {
    await _supabase.auth.updateUser(UserAttributes(password: password));
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  /// Returns the [User] if auto-confirmed, or null if email confirmation is required.
  Future<User?> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    final response = await _supabase.auth.signUp(
      email: email,
      password: password,
      data: {'name': name},
    );
    if (response.user == null) {
      throw Exception('Failed to sign up');
    }
    if (response.session != null) return response.user;
    return null;
  }
}
