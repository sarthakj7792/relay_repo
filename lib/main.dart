import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:relay_repo/app/app.dart';
import 'package:relay_repo/data/models/saved_item.dart';
import 'package:relay_repo/features/folders/models/folder.dart';
import 'package:relay_repo/core/providers/shared_preferences_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'] ?? '',
    anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? '',
  );

  // Listen for auth errors and clear session if refresh token is invalid
  Supabase.instance.client.auth.onAuthStateChange.listen((data) {
    final event = data.event;
    if (event == AuthChangeEvent.tokenRefreshed) {
      // Token refreshed successfully
    }
  });

  // Handle auth exceptions globally
  FlutterError.onError = (FlutterErrorDetails details) {
    if (details.exception is AuthApiException) {
      final authException = details.exception as AuthApiException;
      if (authException.code == 'refresh_token_not_found') {
        // Clear the invalid session
        Supabase.instance.client.auth.signOut();
      }
    }
    FlutterError.presentError(details);
  };

  await Hive.initFlutter();
  Hive.registerAdapter(SavedItemAdapter());
  Hive.registerAdapter(FolderAdapter());
  await Hive.openBox<SavedItem>('saved_items');
  await Hive.openBox<Folder>('folders');
  await Hive.openBox('notifications');
  await Hive.openBox('settings');

  final prefs = await SharedPreferences.getInstance();
  final onboardingCompleted = prefs.getBool('onboarding_completed') ?? false;

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: MyApp(onboardingCompleted: onboardingCompleted),
    ),
  );
}
