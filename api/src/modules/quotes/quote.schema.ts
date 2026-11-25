import { z } from 'zod';

export const createQuoteSchema = z.object({
  requestId: z.string().min(1),
  amount: z.coerce.number().positive(),
  estimatedDays: z.coerce.number().int().positive(),
  message: z.string().max(1000).optional(),
});

export const quoteQuerySchema = z.object({
  requestId: z.string().optional(),
  page: z.coerce.number().int().positive().default(1),
  limit: z.coerce.number().int().positive().max(50).default(10),
});

export type CreateQuoteInput = z.infer<typeof createQuoteSchema>;
export type QuoteQuery = z.infer<typeof quoteQuerySchema>;
