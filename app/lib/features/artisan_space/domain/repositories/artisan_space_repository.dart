import '../../../../core/errors/result.dart';
import '../../../artisans/domain/models/artisan.dart';
import '../../../requests/domain/models/quote.dart';
import '../../../requests/domain/models/service_request.dart';

/// Contrat du repository pour l'espace Artisan (Clean Architecture - F3).
abstract class ArtisanSpaceRepository {
  /// Liste les demandes de service disponibles (ou filtrées par statut/ville/recherche).
  Future<Result<List<ServiceRequest>>> getRequests({
    String? search,
    String? city,
    String? categoryId,
    String? status,
  });

  /// Soumet un devis chiffré pour une demande client (`POST /api/quotes`).
  Future<Result<Quote>> submitQuote({
    required String requestId,
    required double amount,
    required int estimatedDays,
    String? message,
  });

  /// Récupère le(s) devis soumis par l'artisan pour une demande (`GET /api/quotes/request/:requestId`).
  Future<Result<List<Quote>>> getMyQuoteForRequest(String requestId);

  /// Met à jour le statut d'une demande (`PUT /api/requests/:id`).
  Future<Result<ServiceRequest>> updateRequestStatus(
    String requestId,
    String status,
  );

  /// Récupère le profil complet de l'artisan (`GET /api/artisans/:id`).
  Future<Result<Artisan>> getArtisanProfile(String artisanId);

  /// Met à jour le profil ou la disponibilité de l'artisan (`PUT /api/artisans/:id`).
  Future<Result<Artisan>> updateArtisanProfile({
    required String artisanId,
    String? specialty,
    String? city,
    int? experienceYears,
    String? bio,
    String? availability,
  });
}
