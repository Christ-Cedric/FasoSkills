import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import '../network/api_client.dart';
import '../network/ws_client.dart';
import '../storage/cache_service.dart';
import '../storage/secure_storage_service.dart';

import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';

import '../../features/artisans/domain/repositories/artisan_repository.dart';
import '../../features/artisans/data/repositories/artisan_repository_impl.dart';
import '../../features/artisans/presentation/bloc/artisan_list_bloc.dart';

import '../../features/requests/domain/repositories/request_repository.dart';
import '../../features/requests/data/repositories/request_repository_impl.dart';
import '../../features/requests/presentation/bloc/request_bloc.dart';

import '../../features/chat/domain/repositories/chat_repository.dart';
import '../../features/chat/data/repositories/chat_repository_impl.dart';
import '../../features/chat/presentation/bloc/chat_bloc.dart';

final getIt = GetIt.instance;

Future<void> setupDependencyInjection() async {
  // 1. Core Services & Storage
  getIt.registerLazySingleton<SecureStorageService>(() => SecureStorageService());
  getIt.registerLazySingleton<CacheService>(() => CacheService());
  getIt.registerLazySingleton<http.Client>(() => http.Client());

  getIt.registerLazySingleton<ApiClient>(
    () => ApiClient(
      client: getIt<http.Client>(),
      storage: getIt<SecureStorageService>(),
    ),
  );

  getIt.registerLazySingleton<WebSocketClient>(
    () => WebSocketClient(storage: getIt<SecureStorageService>()),
  );

  // 2. Repositories (Domain contracts mapped to Data implementations - F3)
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      apiClient: getIt<ApiClient>(),
      storage: getIt<SecureStorageService>(),
    ),
  );

  getIt.registerLazySingleton<ArtisanRepository>(
    () => ArtisanRepositoryImpl(
      apiClient: getIt<ApiClient>(),
      cacheService: getIt<CacheService>(),
    ),
  );

  getIt.registerLazySingleton<RequestRepository>(
    () => RequestRepositoryImpl(apiClient: getIt<ApiClient>()),
  );

  getIt.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(apiClient: getIt<ApiClient>()),
  );

  // 3. BLoCs / Cubits (State management - F2)
  getIt.registerFactory<AuthBloc>(
    () => AuthBloc(authRepository: getIt<AuthRepository>()),
  );

  getIt.registerFactory<ArtisanListBloc>(
    () => ArtisanListBloc(repository: getIt<ArtisanRepository>()),
  );

  getIt.registerFactory<RequestBloc>(
    () => RequestBloc(repository: getIt<RequestRepository>()),
  );

  getIt.registerFactory<ChatBloc>(
    () => ChatBloc(
      repository: getIt<ChatRepository>(),
      wsClient: getIt<WebSocketClient>(),
    ),
  );
}
