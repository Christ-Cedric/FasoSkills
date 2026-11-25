import '../../../../core/errors/result.dart';
import '../models/artisan.dart';

abstract class ArtisanRepository {
  Future<Result<List<Category>>> getCategories();
  Future<Result<List<Artisan>>> getArtisans({
    int page = 1,
    int limit = 10,
    String? search,
    String? city,
    String? categoryId,
  });
  Future<Result<Artisan>> getArtisanById(String id);
  Future<List<Artisan>?> getCachedArtisans();
}
