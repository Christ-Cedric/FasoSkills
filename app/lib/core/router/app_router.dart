import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/artisans/presentation/screens/home_screen.dart';
import '../../features/artisans/presentation/screens/search_screen.dart';
import '../../features/requests/presentation/screens/my_requests_screen.dart';
import '../../features/requests/presentation/screens/request_quote_screen.dart';
import '../../features/chat/presentation/screens/messages_screen.dart';

class AppRouter {
  final AuthBloc authBloc;

  AppRouter({required this.authBloc});

  late final GoRouter router = GoRouter(
    initialLocation: '/splash',
    refreshListenable: GoRouterRefreshStream(authBloc.stream),
    redirect: (BuildContext context, GoRouterState state) {
      final authState = authBloc.state;
      final isAuth = authState is Authenticated;
      final isLoggingIn = state.matchedLocation == '/login' ||
          state.matchedLocation == '/register' ||
          state.matchedLocation == '/splash';

      // While determining auth status on splash
      if (authState is AuthInitial || authState is AuthLoading) {
        return '/splash';
      }

      // If user is not authenticated and tries to access protected route
      if (!isAuth && !isLoggingIn) {
        return '/login';
      }

      // If user is authenticated and is on auth screens, redirect to home
      if (isAuth && isLoggingIn) {
        return '/home';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/search',
        builder: (context, state) => const SearchScreen(),
      ),
      GoRoute(
        path: '/requests',
        builder: (context, state) => const MyRequestsScreen(),
      ),
      GoRoute(
        path: '/request-quote',
        builder: (context, state) => const RequestQuoteScreen(),
      ),
      GoRoute(
        path: '/messages',
        builder: (context, state) => const MessagesScreen(),
      ),
    ],
  );
}

class GoRouterRefreshStream extends ChangeNotifier {
  late final StreamSubscription<dynamic> _subscription;

  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
