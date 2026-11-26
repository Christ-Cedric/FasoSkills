import '../../../../core/errors/failure.dart';
import '../../../../core/errors/result.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/storage/cache_service.dart';
import '../../../artisans/domain/models/artisan.dart';
import '../../../requests/domain/models/quote.dart';
import '../../../requests/domain/models/service_request.dart';
import '../../domain/repositories/artisan_space_repository.dart';

class ArtisanSpaceRepositoryImpl implements ArtisanSpaceRepository {
  final ApiClient _apiClient;
  final CacheService _cacheService;

  static const String _requestsCacheKey = 'artisan_available_requests_cache';

  ArtisanSpaceRepositoryImpl({
    ApiClient? apiClient,
    CacheService? cacheService,
  })  : _apiClient = apiClient ?? ApiClient(),
        _cacheService = cacheService ?? CacheService();

  @override
  Future<Result<List<ServiceRequest>>> getRequests({
    String? search,
    String? city,
    String? categoryId,
    String? status,
  }) async {
    try {
      final queryParams = <String, String>{};
      if (search != null && search.trim().isNotEmpty) {
        queryParams['search'] = search.trim();
      }
      if (city != null && city.trim().isNotEmpty && city != 'Toutes') {
        queryParams['city'] = city.trim();
      }
      if (categoryId != null && categoryId.isNotEmpty) {
        queryParams['categoryId'] = categoryId;
      }
      if (status != null && status.isNotEmpty && status != 'all') {
        queryParams['status'] = status;
      }

      final res = await _apiClient.get(
        '/requests',
        queryParams: queryParams.isEmpty ? null : queryParams,
      );
      final List list = res['data'] ?? [];
      final requests = list
          .map((e) => ServiceRequest.fromJson(e as Map<String, dynamic>))
          .toList();

      // Cache unfiltered pending requests for offline fallback (F9)
      if (queryParams.isEmpty || status == 'pending') {
        await _cacheService.saveJson(_requestsCacheKey, list);
      }

      return Success(requests);
    } on Failure catch (f) {
      if (f is NetworkFailure) {
        final cached = await _cacheService.getJson(_requestsCacheKey);
        if (cached is List) {
          final cachedRequests = cached
              .map((e) => ServiceRequest.fromJson(e as Map<String, dynamic>))
              .toList();
          return Success(cachedRequests);
        }
      }
      return FailureResult(f);
    } catch (e) {
      return FailureResult(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<Quote>> submitQuote({
    required String requestId,
    required double amount,
    required int estimatedDays,
    String? message,
  }) async {
    try {
      final body = <String, dynamic>{
        'requestId': requestId,
        'amount': amount,
        'estimatedDays': estimatedDays,
      };
      if (message != null && message.trim().isNotEmpty) {
        body['message'] = message.trim();
      }

      final res = await _apiClient.post('/quotes', body: body);
      return Success(Quote.fromJson(res['data'] as Map<String, dynamic>));
    } on Failure catch (f) {
      return FailureResult(f);
    } catch (e) {
      return FailureResult(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<Quote>>> getMyQuoteForRequest(String requestId) async {
    try {
      final res = await _apiClient.get('/quotes/request/$requestId');
      final List list = res['data'] ?? [];
      return Success(
        list.map((e) => Quote.fromJson(e as Map<String, dynamic>)).toList(),
      );
    } on Failure catch (f) {
      return FailureResult(f);
    } catch (e) {
      return FailureResult(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<ServiceRequest>> updateRequestStatus(
    String requestId,
    String status,
  ) async {
    try {
      final res = await _apiClient.put(
        '/requests/$requestId',
        body: {'status': status},
      );
      return Success(
        ServiceRequest.fromJson(res['data'] as Map<String, dynamic>),
      );
    } on Failure catch (f) {
      return FailureResult(f);
    } catch (e) {
      return FailureResult(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<Artisan>> getArtisanProfile(String artisanId) async {
    try {
      final res = await _apiClient.get('/artisans/$artisanId');
      return Success(Artisan.fromJson(res['data'] as Map<String, dynamic>));
    } on Failure catch (f) {
      return FailureResult(f);
    } catch (e) {
      return FailureResult(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<Artisan>> updateArtisanProfile({
    required String artisanId,
    String? specialty,
    String? city,
    int? experienceYears,
    String? bio,
    String? availability,
  }) async {
    try {
      final body = <String, dynamic>{};
      if (specialty != null) body['specialty'] = specialty;
      if (city != null) body['city'] = city;
      if (experienceYears != null) body['experienceYears'] = experienceYears;
      if (bio != null) body['bio'] = bio;
      if (availability != null) body['availability'] = availability;

      final res = await _apiClient.put('/artisans/$artisanId', body: body);
      return Success(Artisan.fromJson(res['data'] as Map<String, dynamic>));
    } on Failure catch (f) {
      return FailureResult(f);
    } catch (e) {
      return FailureResult(ServerFailure(e.toString()));
    }
  }
}
