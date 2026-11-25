import '../../../../core/errors/result.dart';
import '../models/service_request.dart';
import '../models/quote.dart';

abstract class RequestRepository {
  Future<Result<List<ServiceRequest>>> getMyRequests();
  Future<Result<ServiceRequest>> createRequest({
    required String title,
    required String description,
    required String categoryId,
    required String city,
    String? address,
    List<String>? photos,
  });
  Future<Result<ServiceRequest>> cancelRequest(String requestId);
  Future<Result<List<Quote>>> getQuotesForRequest(String requestId);
  Future<Result<Quote>> acceptQuote(String quoteId);
}
