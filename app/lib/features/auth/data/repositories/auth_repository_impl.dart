import '../../../../core/errors/failure.dart';
import '../../../../core/errors/result.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../domain/models/user.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ApiClient _apiClient;
  final SecureStorageService _storage;

  AuthRepositoryImpl({
    ApiClient? apiClient,
    SecureStorageService? storage,
  })  : _apiClient = apiClient ?? ApiClient(),
        _storage = storage ?? SecureStorageService();

  @override
  Future<Result<User>> login(
      {required String email, required String password}) async {
    try {
      final res = await _apiClient.post(
        '/auth/login',
        body: {'email': email, 'password': password},
        requiresAuth: false,
      );

      final data = res['data'];
      await _storage.saveTokens(
        accessToken: data['tokens']['accessToken'],
        refreshToken: data['tokens']['refreshToken'],
      );

      final user = User.fromJson(data['user']);
      return Success(user);
    } on Failure catch (f) {
      return FailureResult(f);
    } catch (e) {
      return FailureResult(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<User>> register({
    required String email,
    required String password,
    required String fullName,
    String? phone,
    required String role,
    String? specialty,
    String? city,
    String? categoryId,
  }) async {
    try {
      final res = await _apiClient.post(
        '/auth/register',
        body: {
          'email': email,
          'password': password,
          'fullName': fullName,
          'phone': phone,
          'role': role,
          'specialty': specialty,
          'city': city,
          'categoryId': categoryId,
        },
        requiresAuth: false,
      );

      final data = res['data'];
      await _storage.saveTokens(
        accessToken: data['tokens']['accessToken'],
        refreshToken: data['tokens']['refreshToken'],
      );

      final user = User.fromJson(data['user']);
      return Success(user);
    } on Failure catch (f) {
      return FailureResult(f);
    } catch (e) {
      return FailureResult(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> logout() async {
    try {
      final refreshToken = await _storage.getRefreshToken();
      if (refreshToken != null) {
        await _apiClient.post(
          '/auth/logout',
          body: {'refreshToken': refreshToken},
          requiresAuth: false,
        );
      }
      await _storage.clearTokens();
      return const Success(null);
    } catch (_) {
      await _storage.clearTokens();
      return const Success(null);
    }
  }

  @override
  Future<Result<User>> getCurrentUser() async {
    try {
      final res = await _apiClient.get('/auth/me');
      final user = User.fromJson(res['data']['user']);
      return Success(user);
    } on Failure catch (f) {
      return FailureResult(f);
    } catch (e) {
      return FailureResult(ServerFailure(e.toString()));
    }
  }

  @override
  Future<bool> hasValidToken() async {
    final token = await _storage.getAccessToken();
    return token != null && token.isNotEmpty;
  }
}
