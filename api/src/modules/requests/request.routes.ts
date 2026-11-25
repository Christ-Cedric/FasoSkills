import { Router } from 'express';
import { serviceRequestController } from './request.controller.js';
import { validate } from '../../core/middlewares/validate.js';
import { createRequestSchema, updateRequestSchema, requestQuerySchema } from './request.schema.js';
import { authenticate } from '../../core/middlewares/auth.js';

const router = Router();

router.get('/', validate({ query: requestQuerySchema }), serviceRequestController.list);
router.get('/:id', serviceRequestController.getById);
router.post('/', authenticate, validate({ body: createRequestSchema }), serviceRequestController.create);
router.put('/:id', authenticate, validate({ body: updateRequestSchema }), serviceRequestController.update);
router.delete('/:id', authenticate, serviceRequestController.cancel);

export default router;
