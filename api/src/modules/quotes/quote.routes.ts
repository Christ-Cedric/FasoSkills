import { Router } from 'express';
import { quoteController } from './quote.controller.js';
import { validate } from '../../core/middlewares/validate.js';
import { createQuoteSchema, quoteQuerySchema } from './quote.schema.js';
import { authenticate, requireRole } from '../../core/middlewares/auth.js';

const router = Router();

router.post('/', authenticate, requireRole(['artisan']), validate({ body: createQuoteSchema }), quoteController.create);
router.get('/request/:requestId', authenticate, validate({ query: quoteQuerySchema }), quoteController.listForRequest);
router.post('/:id/accept', authenticate, requireRole(['client']), quoteController.accept);

export default router;
