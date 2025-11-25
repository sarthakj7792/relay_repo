import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:relay_repo/app/router.dart';
import 'package:relay_repo/core/theme/app_theme.dart';
import 'package:relay_repo/core/theme/theme_view_model.dart';

class MyApp extends ConsumerWidget {
  final bool onboardingCompleted;
  const MyApp({super.key, required this.onboardingCompleted});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider(onboardingCompleted));
    final themeMode = ref.watch(themeViewModelProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'All-in-One Video Saver',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}
