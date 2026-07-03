import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepo {
  final SupabaseClient _client;
  AuthRepo(this._client);

  Stream<AuthState> get authStateChange => _client.auth.onAuthStateChange;
  User? get currentUser => _client.auth.currentUser;

  //====================Sign Up =====================//
  Future<void> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    final response = await _client.auth.signUp(
      email: email,
      password: password,
      data: {'name': name},
    );
    if (response.user == null) {
      throw Exception("Failed to Sign up");
    }
  }

  //================= Sign In ====================//
  Future<void> signIn({required String email, required String password}) async {
    final response = await _client.auth.signInWithPassword(
      password: password,
      email: email,
    );

    if (response.user == null) {
      throw Exception('Failed to Sign in');
    }
  }

  //============== Sign out=============//
  Future<void> signOut() async {
    await _client.auth.signOut();
  }
}
