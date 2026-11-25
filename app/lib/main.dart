import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/di/injection.dart';
import 'core/network/ws_client.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/artisans/presentation/bloc/artisan_list_bloc.dart';
import 'features/requests/presentation/bloc/request_bloc.dart';
import 'features/chat/presentation/bloc/chat_bloc.dart';
import 'features/admin/dashboard/presentation/bloc/admin_dashboard_bloc.dart';
import 'features/admin/artisans/presentation/bloc/admin_artisans_bloc.dart';
import 'features/admin/categories/presentation/bloc/categories_bloc.dart';
import 'features/admin/moderation/presentation/bloc/moderation_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // F4: Single composition root via GetIt
  await setupDependencyInjection();

  // Initialize WebSocket connection for real-time updates
  getIt<WebSocketClient>().connect();

  runApp(const FasoSkillsApp());
}

class FasoSkillsApp extends StatefulWidget {
  const FasoSkillsApp({super.key});

  @override
  State<FasoSkillsApp> createState() => _FasoSkillsAppState();
}

class _FasoSkillsAppState extends State<FasoSkillsApp> {
  late final AuthBloc _authBloc;
  late final AppRouter _appRouter;

  @override
  void initState() {
    super.initState();
    _authBloc = getIt<AuthBloc>();
    // F5: Declarative navigation with auth-driven & role-driven route guard
    _appRouter = AppRouter(authBloc: _authBloc);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>.value(value: _authBloc),
        BlocProvider<ArtisanListBloc>(create: (_) => getIt<ArtisanListBloc>()),
        BlocProvider<RequestBloc>(create: (_) => getIt<RequestBloc>()),
        BlocProvider<ChatBloc>(create: (_) => getIt<ChatBloc>()),
        BlocProvider<AdminDashboardBloc>(
          create: (_) => getIt<AdminDashboardBloc>(),
        ),
        BlocProvider<AdminArtisansBloc>(
          create: (_) => getIt<AdminArtisansBloc>(),
        ),
        BlocProvider<CategoriesBloc>(create: (_) => getIt<CategoriesBloc>()),
        BlocProvider<ModerationBloc>(create: (_) => getIt<ModerationBloc>()),
      ],
      child: MaterialApp.router(
        title: 'FasoSkills',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        routerConfig: _appRouter.router,
      ),
    );
  }
}
