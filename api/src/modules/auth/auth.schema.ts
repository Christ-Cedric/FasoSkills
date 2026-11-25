import { z } from 'zod';

export const registerSchema = z.object({
  email: z.string().email(),
  phone: z.string().min(8).max(20).optional(),
  fullName: z.string().min(2).max(100),
  password: z.string().min(6, 'Password must be at least 6 characters'),
  role: z.enum(['client', 'artisan']).default('client'),
  // Artisan optional initial fields
  specialty: z.string().optional(),
  city: z.string().optional(),
  categoryId: z.string().optional(),
});

export const loginSchema = z.object({
  email: z.string().email(),
  password: z.string().min(1),
});

export const refreshSchema = z.object({
  refreshToken: z.string().min(1),
});

export type RegisterInput = z.infer<typeof registerSchema>;
export type LoginInput = z.infer<typeof loginSchema>;
export type RefreshInput = z.infer<typeof refreshSchema>;
