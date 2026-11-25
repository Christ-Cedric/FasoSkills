import { z } from 'zod';

export const startConversationSchema = z.object({
  recipientId: z.string().min(1),
  initialMessage: z.string().min(1).max(2000).optional(),
});

export const sendMessageSchema = z.object({
  text: z.string().min(1).max(2000),
});

export type StartConversationInput = z.infer<typeof startConversationSchema>;
export type SendMessageInput = z.infer<typeof sendMessageSchema>;
