import { Router } from 'express';
import { chatController } from './chat.controller.js';
import { validate } from '../../core/middlewares/validate.js';
import { startConversationSchema, sendMessageSchema } from './chat.schema.js';
import { authenticate } from '../../core/middlewares/auth.js';

const router = Router();

router.use(authenticate);

router.post('/conversations', validate({ body: startConversationSchema }), chatController.startOrGet);
router.get('/conversations', chatController.list);
router.get('/conversations/:conversationId/messages', chatController.getMessages);
router.post('/conversations/:conversationId/messages', validate({ body: sendMessageSchema }), chatController.send);

export default router;
