import { z } from 'zod';

export const updateArtisanProfileSchema = z.object({
  specialty: z.string().min(2).max(150).optional(),
  city: z.string().min(2).max(100).optional(),
  categoryId: z.string().optional(),
  experienceYears: z.coerce.number().min(0).max(50).optional(),
  bio: z.string().max(1000).optional(),
  availability: z.string().max(100).optional(),
});

export const artisanQuerySchema = z.object({
  page: z.coerce.number().int().positive().default(1),
  limit: z.coerce.number().int().positive().max(50).default(10),
  search: z.string().optional(),
  city: z.string().optional(),
  categoryId: z.string().optional(),
  minRating: z.coerce.number().min(0).max(5).optional(),
});

export type UpdateArtisanProfileInput = z.infer<typeof updateArtisanProfileSchema>;
export type ArtisanQuery = z.infer<typeof artisanQuerySchema>;
