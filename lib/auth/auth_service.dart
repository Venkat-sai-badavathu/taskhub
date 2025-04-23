import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';

class AuthService with ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;

  User? get currentUser => _supabase.auth.currentUser;
  bool get isLoggedIn => currentUser != null;
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;

  Future<void> signUpWithEmail({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      // 1. Create user in auth
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {
          'username': username,
        }, // Optional: stores in auth.users.user_metadata
      );

      // 2. Insert into profiles table
      await _supabase.from('profiles').upsert({
        'id': response.user!.id,
        'username': username,
        'email': email,
      });

      if (response.user?.confirmedAt == null) {
        throw AuthException('Please verify your email before logging in');
      }
    } on PostgrestException catch (e) {
      if (e.code == '23505') {
        throw AuthException('Username already exists');
      }
      throw AuthException('Registration failed');
    } catch (e) {
      throw AuthException('Registration failed');
    }
  }

  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      await _supabase.auth.signInWithPassword(email: email, password: password);
    } on AuthException catch (e) {
      throw _parseAuthError(e.message);
    } catch (e) {
      throw const AuthException('Login failed. Please try again.');
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      await _supabase.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'io.supabase.flutterquickstart://login-callback',
      );
    } on AuthException catch (e) {
      throw _parseAuthError(e.message);
    } catch (e) {
      throw const AuthException('Google sign-in failed. Please try again.');
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      if (!_isValidEmail(email)) {
        throw const AuthException('Please enter a valid email address');
      }

      await _supabase.auth.resetPasswordForEmail(
        email,
        redirectTo: 'io.supabase.flutterquickstart://reset-password',
      );
    } on AuthException catch (e) {
      throw _parseAuthError(e.message);
    } catch (e) {
      throw const AuthException('Password reset failed. Please try again.');
    }
  }

  Future<void> updatePassword(String newPassword) async {
    try {
      await _supabase.auth.updateUser(UserAttributes(password: newPassword));
    } on AuthException catch (e) {
      throw _parseAuthError(e.message);
    }
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
    notifyListeners();
  }

  // --- Helpers ---
  bool _isValidEmail(String email) {
    return RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    ).hasMatch(email);
  }

  AuthException _parseAuthError(String message) {
    const errorMap = {
      'Invalid login credentials': 'Wrong email or password',
      'Email not confirmed': 'Please verify your email first',
      'User already registered': 'Account already exists',
    };

    return AuthException(errorMap[message] ?? message);
  }
}

class AuthException implements Exception {
  final String message;
  const AuthException(this.message);

  @override
  String toString() => message;
}

Future<void> _logout(BuildContext context) async {
  final authService = Provider.of<AuthService>(context, listen: false);
  try {
    await authService.signOut();
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  } catch (e) {
    // Error handling
  }
}
