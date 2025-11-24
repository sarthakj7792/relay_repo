import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:relay_repo/features/home/view/home_screen.dart';
import 'package:relay_repo/features/auth/view/login_screen.dart';
import 'package:relay_repo/features/auth/view/signup_screen.dart';
import 'package:relay_repo/features/onboarding/view/onboarding_screen.dart';
import 'package:relay_repo/features/auth/view/reset_password_screen.dart';

import 'package:relay_repo/data/repositories/auth_repository.dart';

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

      // We will handle the onboarding check in the UI or a separate provider for simplicity
      // But strictly, if not logged in, we might want to go to onboarding first.
      // For now, let's assume if we are at onboarding, we stay there.

      if (session == null) {
        if (isOnboarding) return null;
        return isLoggingIn ? null : '/login';
      }

      if (isLoggingIn || isOnboarding) return '/';

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
    ],
  );
});

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.listen(
      (dynamic _) => notifyListeners(),
    );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
