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
import '../../features/admin/dashboard/presentation/screens/admin_dashboard_screen.dart';
import '../../features/admin/artisans/presentation/screens/admin_artisans_screen.dart';
import '../../features/admin/artisans/presentation/screens/admin_artisan_detail_screen.dart';
import '../../features/admin/categories/presentation/screens/admin_categories_screen.dart';
import '../../features/admin/moderation/presentation/screens/admin_moderation_screen.dart';
import '../../features/admin/profile/presentation/screens/admin_profile_screen.dart';

class AppRouter {
  final AuthBloc authBloc;

  AppRouter({required this.authBloc});

  late final GoRouter router = GoRouter(
    initialLocation: '/splash',
    refreshListenable: GoRouterRefreshStream(authBloc.stream),
    redirect: (BuildContext context, GoRouterState state) {
      final authState = authBloc.state;
      final loc = state.matchedLocation;
      final isAuth = authState is Authenticated;
      final isAdmin = isAuth && authState.user.isAdmin;
      final isAuthScreen =
          loc == '/login' || loc == '/register' || loc == '/splash';

      // While checking initial session on splash
      if (authState is AuthInitial) {
        return loc == '/splash' ? null : '/splash';
      }
      if (authState is AuthLoading && loc == '/splash') {
        return null;
      }

      // Unauthenticated user trying to access any protected route -> /login (F5)
      if (!isAuth) {
        if (loc == '/splash') return '/login';
        return isAuthScreen ? null : '/login';
      }

      // Authenticated user on auth screens -> redirect to role home
      if (isAuthScreen) {
        return isAdmin ? '/admin/dashboard' : '/home';
      }

      // Guard F5 & §7.2: non-admin user trying to access /admin/** -> role home
      if (loc.startsWith('/admin') && !isAdmin) {
        return '/home';
      }

      // Admin user stays inside admin console
      if (!loc.startsWith('/admin') && isAdmin) {
        return '/admin/dashboard';
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
      // ── Admin Routes (§7.2) ──────────────────────────────────────────────
      GoRoute(
        path: '/admin/dashboard',
        builder: (context, state) => const AdminDashboardScreen(),
      ),
      GoRoute(
        path: '/admin/artisans',
        builder: (context, state) => const AdminArtisansScreen(),
      ),
      GoRoute(
        path: '/admin/artisans/:id',
        builder: (context, state) => AdminArtisanDetailScreen(
          artisanId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/admin/categories',
        builder: (context, state) => const AdminCategoriesScreen(),
      ),
      GoRoute(
        path: '/admin/moderation',
        builder: (context, state) => const AdminModerationScreen(),
      ),
      GoRoute(
        path: '/admin/profile',
        builder: (context, state) => const AdminProfileScreen(),
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
