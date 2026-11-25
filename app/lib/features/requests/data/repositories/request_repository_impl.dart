import '../../../../core/errors/failure.dart';
import '../../../../core/errors/result.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/models/service_request.dart';
import '../../domain/models/quote.dart';
import '../../domain/repositories/request_repository.dart';

class RequestRepositoryImpl implements RequestRepository {
  final ApiClient _apiClient;

  RequestRepositoryImpl({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  @override
  Future<Result<List<ServiceRequest>>> getMyRequests() async {
    try {
      final res =
          await _apiClient.get('/requests', queryParams: {'myOnly': 'true'});
      final List list = res['data'] ?? [];
      return Success(list.map((e) => ServiceRequest.fromJson(e)).toList());
    } on Failure catch (f) {
      return FailureResult(f);
    } catch (e) {
      return FailureResult(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<ServiceRequest>> createRequest({
    required String title,
    required String description,
    required String categoryId,
    required String city,
    String? address,
    List<String>? photos,
  }) async {
    try {
      final res = await _apiClient.post(
        '/requests',
        body: {
          'title': title,
          'description': description,
          'categoryId': categoryId,
          'city': city,
          'address': address,
          'photos': photos ?? [],
        },
      );
      return Success(ServiceRequest.fromJson(res['data']));
    } on Failure catch (f) {
      return FailureResult(f);
    } catch (e) {
      return FailureResult(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<ServiceRequest>> cancelRequest(String requestId) async {
    try {
      final res = await _apiClient.delete('/requests/$requestId');
      return Success(ServiceRequest.fromJson(res['data']));
    } on Failure catch (f) {
      return FailureResult(f);
    } catch (e) {
      return FailureResult(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<Quote>>> getQuotesForRequest(String requestId) async {
    try {
      final res = await _apiClient.get('/quotes/request/$requestId');
      final List list = res['data'] ?? [];
      return Success(list.map((e) => Quote.fromJson(e)).toList());
    } on Failure catch (f) {
      return FailureResult(f);
    } catch (e) {
      return FailureResult(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<Quote>> acceptQuote(String quoteId) async {
    try {
      final res = await _apiClient.post('/quotes/$quoteId/accept');
      return Success(Quote.fromJson(res['data']));
    } on Failure catch (f) {
      return FailureResult(f);
    } catch (e) {
      return FailureResult(ServerFailure(e.toString()));
    }
  }
}
