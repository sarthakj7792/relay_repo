import 'dart:async';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:relay_repo/core/utils/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:relay_repo/core/providers/shared_preferences_provider.dart';

class AuthRepository {
  final SupabaseClient _client;
  final SharedPreferences _prefs;

  AuthRepository(this._client, this._prefs);

  static const String _guestKey = 'is_guest';
  final _guestStatusController = StreamController<void>.broadcast();

  bool get isGuest => _prefs.getBool(_guestKey) ?? false;
  Stream<void> get guestStatusStream => _guestStatusController.stream;

  Future<void> signInAsGuest() async {
    await _prefs.setBool(_guestKey, true);
    _guestStatusController.add(null);
  }

  Future<AuthResponse> signUp({
    required String email,
    required String password,
    String? fullName,
  }) async {
    try {
      return await _client.auth.signUp(
        email: email,
        password: password,
        data: fullName != null ? {'full_name': fullName} : null,
      );
    } catch (e) {
      Logger.logger(e.toString());
      return AuthResponse(session: null, user: null);
    }
  }

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    // Ensure guest mode is off
    await _prefs.setBool(_guestKey, false);
    return await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    if (isGuest) {
      await _prefs.setBool(_guestKey, false);
    } else {
      await _client.auth.signOut();
    }
  }

  Future<void> resetPassword(String email) async {
    await _client.auth.resetPasswordForEmail(
      email,
      redirectTo: 'io.supabase.relayrepo://login-callback',
    );
  }

  Future<UserResponse> updatePassword(String newPassword) async {
    return await _client.auth.updateUser(
      UserAttributes(password: newPassword),
    );
  }

  Future<UserResponse> updateUserName(String name) async {
    return await _client.auth.updateUser(
      UserAttributes(data: {'full_name': name}),
    );
  }

  Future<void> uploadProfileImage(String filePath) async {
    final user = _client.auth.currentUser;
    if (user == null) return;

    final fileExt = filePath.split('.').last;
    final fileName = '${user.id}/profile.$fileExt';

    try {
      // Upload image to 'avatars' bucket
      await _client.storage.from('avatars').upload(
            fileName,
            File(filePath),
            fileOptions: const FileOptions(upsert: true),
          );

      // Get public URL
      final imageUrl = _client.storage.from('avatars').getPublicUrl(fileName);

      // Update user metadata
      await _client.auth.updateUser(
        UserAttributes(data: {'avatar_url': imageUrl}),
      );
    } catch (e) {
      Logger.logger('Error uploading profile image: $e');
      rethrow;
    }
  }

  User? get currentUser => _client.auth.currentUser;

  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return AuthRepository(Supabase.instance.client, prefs);
});

final authStateProvider = StreamProvider<AuthState>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
});
