import { ArtisanProfile } from './artisan.model.js';
import { User } from '../auth/auth.model.js';
import { NotFoundError, ForbiddenError } from '../../core/errors/app-error.js';
import { formatPaginatedResult, type PaginatedResult } from '../../core/utils/pagination.js';
import type { ArtisanQuery, UpdateArtisanProfileInput } from './artisan.schema.js';

export class ArtisanService {
  public async list(query: ArtisanQuery): Promise<PaginatedResult<any>> {
    const { page, limit, search, city, categoryId, minRating } = query;
    const filter: Record<string, any> = {};

    if (city) filter.city = new RegExp(city, 'i');
    if (categoryId) filter.category = categoryId;
    if (minRating) filter.rating = { $gte: minRating };

    if (search) {
      filter.$or = [
        { specialty: new RegExp(search, 'i') },
        { bio: new RegExp(search, 'i') },
      ];
    }

    const skip = (page - 1) * limit;

    const [profiles, total] = await Promise.all([
      ArtisanProfile.find(filter)
        .populate('userId', 'fullName email phone profilePicture isVerified')
        .populate('category', 'name slug icon')
        .sort({ rating: -1, completedJobs: -1 })
        .skip(skip)
        .limit(limit)
        .lean(),
      ArtisanProfile.countDocuments(filter),
    ]);

    return formatPaginatedResult(profiles, total, page, limit);
  }

  public async getById(id: string) {
    const profile = await ArtisanProfile.findById(id)
      .populate('userId', 'fullName email phone profilePicture isVerified')
      .populate('category', 'name slug icon');
    if (!profile) throw new NotFoundError('Artisan profile');
    return profile;
  }

  public async updateProfile(profileId: string, userId: string, userRole: string, data: UpdateArtisanProfileInput) {
    const profile = await ArtisanProfile.findById(profileId);
    if (!profile) throw new NotFoundError('Artisan profile');

    // Object-level authorization: Only the artisan owner or an admin can edit
    if (profile.userId.toString() !== userId && userRole !== 'admin') {
      throw new ForbiddenError('You can only update your own artisan profile');
    }

    if (data.specialty !== undefined) profile.specialty = data.specialty;
    if (data.city !== undefined) profile.city = data.city;
    if (data.categoryId !== undefined) profile.category = data.categoryId as any;
    if (data.experienceYears !== undefined) profile.experienceYears = data.experienceYears;
    if (data.bio !== undefined) profile.bio = data.bio;
    if (data.availability !== undefined) profile.availability = data.availability;

    if (profile.specialty && profile.city && profile.category) {
      profile.profileStatus = 'complete';
    }

    await profile.save();
    return profile.populate([
      { path: 'userId', select: 'fullName email phone profilePicture isVerified' },
      { path: 'category', select: 'name slug icon' },
    ]);
  }

  public async verifyArtisan(profileId: string, isAdmin: boolean) {
    if (!isAdmin) throw new ForbiddenError('Only administrators can verify artisans');
    const profile = await ArtisanProfile.findById(profileId);
    if (!profile) throw new NotFoundError('Artisan profile');
    profile.isVerified = true;
    await profile.save();
    await User.findByIdAndUpdate(profile.userId, { isVerified: true });
    return profile;
  }
}

export const artisanService = new ArtisanService();
