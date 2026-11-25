import { Review } from './review.model.js';
import { ServiceRequest } from '../requests/request.model.js';
import { ArtisanProfile } from '../artisans/artisan.model.js';
import { NotFoundError, ForbiddenError, ConflictError } from '../../core/errors/app-error.js';
import { formatPaginatedResult, type PaginatedResult } from '../../core/utils/pagination.js';
import type { CreateReviewInput, ReviewQuery } from './review.schema.js';

export class ReviewService {
  public async create(clientId: string, data: CreateReviewInput) {
    const request = await ServiceRequest.findById(data.requestId);
    if (!request) throw new NotFoundError('Service request');

    // Rule: Review only by the client of this request
    if (request.clientId.toString() !== clientId) {
      throw new ForbiddenError('Only the client who created the request can leave a review');
    }

    // Rule: Review only for completed jobs! (T18 requirement)
    if (request.status !== 'completed') {
      throw new ConflictError('Reviews can only be submitted for completed service requests');
    }

    const existing = await Review.findOne({ requestId: request._id });
    if (existing) {
      throw new ConflictError('A review has already been submitted for this request');
    }

    const review = await Review.create({
      requestId: request._id,
      clientId,
      artisanId: data.artisanId,
      rating: data.rating,
      comment: data.comment || '',
    });

    // Update artisan rating and completedJobs count
    const artisanReviews = await Review.find({ artisanId: data.artisanId });
    const totalRating = artisanReviews.reduce((sum, r) => sum + r.rating, 0);
    const avgRating = Number((totalRating / artisanReviews.length).toFixed(1));

    await ArtisanProfile.findByIdAndUpdate(data.artisanId, {
      rating: avgRating,
      reviewsCount: artisanReviews.length,
      $inc: { completedJobs: 1 },
    });

    return review.populate({
      path: 'clientId',
      select: 'fullName profilePicture',
    });
  }

  public async listForArtisan(artisanId: string, query: ReviewQuery): Promise<PaginatedResult<any>> {
    const page = query.page || 1;
    const limit = query.limit || 10;
    const skip = (page - 1) * limit;

    const [reviews, total] = await Promise.all([
      Review.find({ artisanId })
        .populate('clientId', 'fullName profilePicture')
        .sort({ createdAt: -1 })
        .skip(skip)
        .limit(limit)
        .lean(),
      Review.countDocuments({ artisanId }),
    ]);

    return formatPaginatedResult(reviews, total, page, limit);
  }
}

export const reviewService = new ReviewService();
