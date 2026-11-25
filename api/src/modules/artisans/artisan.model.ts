import mongoose, { Schema, type Document } from 'mongoose';

export interface IArtisanProfile extends Document {
  userId: mongoose.Types.ObjectId;
  category?: mongoose.Types.ObjectId;
  specialty: string;
  city: string;
  experienceYears: number;
  bio: string;
  availability: string;
  rating: number;
  reviewsCount: number;
  completedJobs: number;
  isVerified: boolean;
  profileStatus: 'incomplete' | 'complete';
  createdAt: Date;
  updatedAt: Date;
}

const artisanProfileSchema = new Schema<IArtisanProfile>(
  {
    userId: { type: Schema.Types.ObjectId, ref: 'User', required: true, unique: true, index: true },
    category: { type: Schema.Types.ObjectId, ref: 'Category', index: true },
    specialty: { type: String, default: '', trim: true },
    city: { type: String, default: 'Ouagadougou', trim: true, index: true },
    experienceYears: { type: Number, default: 0, min: 0 },
    bio: { type: String, default: '' },
    availability: { type: String, default: 'Disponible' },
    rating: { type: Number, default: 0, min: 0, max: 5, index: true },
    reviewsCount: { type: Number, default: 0, min: 0 },
    completedJobs: { type: Number, default: 0, min: 0 },
    isVerified: { type: Boolean, default: false, index: true },
    profileStatus: { type: String, enum: ['incomplete', 'complete'], default: 'incomplete' },
  },
  { timestamps: true }
);

// Compound indexes for search and filtering - Requirement A10
artisanProfileSchema.index({ category: 1, city: 1 });
artisanProfileSchema.index({ specialty: 'text', bio: 'text' });

export const ArtisanProfile = mongoose.model<IArtisanProfile>('ArtisanProfile', artisanProfileSchema);
