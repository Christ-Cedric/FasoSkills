import { z } from 'zod';

export const createRequestSchema = z.object({
  title: z.string().min(5).max(200),
  description: z.string().min(10),
  categoryId: z.string().min(1),
  city: z.string().min(2).max(100),
  address: z.string().optional(),
  photos: z.array(z.string()).optional().default([]),
});

export const updateRequestSchema = z.object({
  title: z.string().min(5).max(200).optional(),
  description: z.string().min(10).optional(),
  city: z.string().min(2).max(100).optional(),
  address: z.string().optional(),
  status: z.enum(['pending', 'in_progress', 'completed', 'cancelled']).optional(),
});

export const requestQuerySchema = z.object({
  page: z.coerce.number().int().positive().default(1),
  limit: z.coerce.number().int().positive().max(50).default(10),
  search: z.string().optional(),
  city: z.string().optional(),
  categoryId: z.string().optional(),
  status: z.string().optional(),
  myOnly: z.enum(['true', 'false']).optional(),
});

export type CreateRequestInput = z.infer<typeof createRequestSchema>;
export type UpdateRequestInput = z.infer<typeof updateRequestSchema>;
export type RequestQuery = z.infer<typeof requestQuerySchema>;
