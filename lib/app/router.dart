import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:relay_repo/features/home/view/home_screen.dart';
import 'package:relay_repo/features/auth/view/login_screen.dart';
import 'package:relay_repo/features/auth/view/signup_screen.dart';
import 'package:relay_repo/features/onboarding/view/onboarding_screen.dart';
import 'package:relay_repo/features/auth/view/reset_password_screen.dart';
import 'package:relay_repo/features/auth/view/update_password_screen.dart';

import 'package:relay_repo/data/repositories/auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final routerProvider =
    Provider.family<GoRouter, bool>((ref, onboardingCompleted) {
  final authRepository = ref.watch(authRepositoryProvider);

  return GoRouter(
    initialLocation: onboardingCompleted ? '/' : '/onboarding',
    refreshListenable: GoRouterRefreshStream(authRepository.authStateChanges),
    redirect: (context, state) {
      final session = ref.read(authRepositoryProvider).currentUser;
      final isLoggingIn =
          state.uri.toString() == '/login' || state.uri.toString() == '/signup';
      final isOnboarding = state.uri.toString() == '/onboarding';
      final isResettingPassword = state.uri.toString() == '/reset-password';
      final isUpdatingPassword = state.uri.toString() == '/update-password';

      // Check if we are in password recovery mode
      // We need to access the stream listener state, but since it's inside the refreshListenable,
      // we might need a better way to pass this state.
      // However, Supabase session will be valid after clicking the link.
      // We can check if the current route is /update-password or if we should redirect there.

      // Note: In a real app, we might want to store the 'recovery mode' in a provider
      // For now, let's rely on the fact that if we are logged in and the event was passwordRecovery,
      // we should go to update password.
      // But since we can't easily access the event here without a provider,
      // let's check if the URL contains the recovery token or if we are already on the update page.

      // Actually, GoRouterRefreshStream is just a ChangeNotifier.
      // We can't easily read the internal state of the refreshListenable from here.
      // A better approach is to have a provider for "isPasswordRecovery".

      // Let's use a simple check: if we are authenticated and the user is trying to go to /update-password, let them.

      if (session == null) {
        if (isOnboarding) return null;
        if (isResettingPassword) return null;
        if (isUpdatingPassword) {
          return '/login'; // Must be logged in to update password
        }
        return isLoggingIn ? null : '/login';
      }

      // If logged in
      if (isLoggingIn || isOnboarding || isResettingPassword) return '/';

      // If we are on update password, allow it
      if (isUpdatingPassword) return null;

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/reset-password',
        builder: (context, state) => const ResetPasswordScreen(),
      ),
      GoRoute(
        path: '/update-password',
        builder: (context, state) => const UpdatePasswordScreen(),
      ),
    ],
  );
});

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<AuthState> stream) {
    notifyListeners();
    _subscription = stream.listen(
      (AuthState state) {
        if (state.event == AuthChangeEvent.passwordRecovery) {
          _isPasswordRecovery = true;
        }
        notifyListeners();
      },
    );
  }

  late final StreamSubscription<dynamic> _subscription;
  bool _isPasswordRecovery = false;

  bool get isPasswordRecovery => _isPasswordRecovery;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
