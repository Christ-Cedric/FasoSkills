import { z } from 'zod';

export const createCategorySchema = z.object({
  name: z.string().min(2).max(100),
  icon: z.string().optional(),
  description: z.string().optional(),
});

export const updateCategorySchema = createCategorySchema.partial();
