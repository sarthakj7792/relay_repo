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
    refreshListenable: GoRouterRefreshStream(
      authRepository.authStateChanges,
      authRepository.guestStatusStream,
    ),
    redirect: (context, state) {
      final session = authRepository.currentUser;
      final isGuest = authRepository.isGuest;
      final isLoggingIn =
          state.uri.toString() == '/login' || state.uri.toString() == '/signup';
      final isOnboarding = state.uri.toString() == '/onboarding';
      final isResettingPassword = state.uri.toString() == '/reset-password';
      final isUpdatingPassword = state.uri.toString() == '/update-password';

      if (session == null && !isGuest) {
        if (isOnboarding) return null;
        if (isResettingPassword) return null;
        if (isUpdatingPassword) {
          return '/login'; // Must be logged in to update password
        }
        return isLoggingIn ? null : '/login';
      }

      // If logged in or guest
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
  GoRouterRefreshStream(
      Stream<AuthState> authStream, Stream<void> guestStream) {
    notifyListeners();
    _authSubscription = authStream.listen(
      (AuthState state) {
        if (state.event == AuthChangeEvent.passwordRecovery) {
          _isPasswordRecovery = true;
        }
        notifyListeners();
      },
    );
    _guestSubscription = guestStream.listen((_) {
      notifyListeners();
    });
  }

  late final StreamSubscription<dynamic> _authSubscription;
  late final StreamSubscription<dynamic> _guestSubscription;
  bool _isPasswordRecovery = false;

  bool get isPasswordRecovery => _isPasswordRecovery;

  @override
  void dispose() {
    _authSubscription.cancel();
    _guestSubscription.cancel();
    super.dispose();
  }
}
