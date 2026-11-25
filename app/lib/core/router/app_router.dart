import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/profile_screen.dart';
import '../../features/artisans/presentation/screens/home_screen.dart';
import '../../features/artisans/presentation/screens/search_screen.dart';
import '../../features/artisans/presentation/screens/service_details_screen.dart';
import '../../features/artisans/presentation/screens/artisans_list_screen.dart';
import '../../features/artisans/presentation/screens/artisan_detail_screen.dart';
import '../../features/requests/presentation/screens/my_requests_screen.dart';
import '../../features/requests/presentation/screens/request_quote_screen.dart';
import '../../features/requests/presentation/screens/portfolio_screen.dart';
import '../../features/chat/presentation/screens/discussions_list_screen.dart';
import '../../features/chat/presentation/screens/chat_detail_screen.dart';
import '../../features/admin/dashboard/presentation/screens/admin_dashboard_screen.dart';
import '../../features/admin/artisans/presentation/screens/admin_artisans_screen.dart';
import '../../features/admin/artisans/presentation/screens/admin_artisan_detail_screen.dart';
import '../../features/admin/categories/presentation/screens/admin_categories_screen.dart';
import '../../features/admin/moderation/presentation/screens/admin_moderation_screen.dart';
import '../../features/admin/profile/presentation/screens/admin_profile_screen.dart';
import '../../features/chat/presentation/screens/contact_screen.dart';

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
      final isAuthScreen = loc == '/login' || loc == '/register';
      final isSplash = loc == '/splash';

      // Initial session check: show splash without redirecting away from it.
      if (authState is AuthInitial) {
        return isSplash ? null : '/splash';
      }

      // Session check in progress on splash: wait there.
      // AuthLoading elsewhere (login, register, logout) must not bounce to splash.
      if (authState is AuthLoading && isSplash) {
        return null;
      }

      // Unauthenticated users may stay on the login and registration screens.
      if (!isAuth) {
        return isAuthScreen ? null : '/login';
      }

      // Once the session check is complete, leave splash and auth screens.
      if (isAuthScreen || isSplash) {
        return isAdmin ? '/admin/dashboard' : '/home';
      }

      // Protect the administration area from non-admin accounts.
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
        builder: (context, state) => const DiscussionsListScreen(),
      ),
      GoRoute(
        path: '/discussions',
        builder: (context, state) => const DiscussionsListScreen(),
      ),
      GoRoute(
        path: '/chat-detail',
        builder: (context, state) => ChatDetailScreen(
          conversationData: state.extra as Map<String, dynamic>?,
        ),
      ),
      GoRoute(
        path: '/artisans-list',
        builder: (context, state) => ArtisansListScreen(
          initialCategory: state.extra as String?,
        ),
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
      GoRoute(
        path: '/service-details',
        builder: (context, state) => ServiceDetailsScreen(
          serviceData: state.extra as Map<String, dynamic>?,
        ),
      ),
      GoRoute(
        path: '/portfolio',
        builder: (context, state) => const PortfolioScreen(),
      ),
      GoRoute(
        path: '/artisan-detail',
        builder: (context, state) => ArtisanDetailScreen(
          artisanData: state.extra,
        ),
      ),
      GoRoute(
        path: '/contact',
        builder: (context, state) => ContactScreen(
          artisan: state.extra,
        ),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
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
