import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:relay_repo/app/app.dart';
import 'package:relay_repo/data/models/saved_item.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'] ?? '',
    anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? '',
  );

  await Hive.initFlutter();
  Hive.registerAdapter(SavedItemAdapter());
  await Hive.openBox<SavedItem>('saved_items');

  final prefs = await SharedPreferences
      .getInstance(); // Added SharedPreferences initialization
  final onboardingCompleted =
      prefs.getBool('onboarding_completed') ?? false; // Added onboarding check

  runApp(
    ProviderScope(
      // Removed const
      child: MyApp(
          onboardingCompleted:
              onboardingCompleted), // Passed onboardingCompleted
    ),
  );
}
