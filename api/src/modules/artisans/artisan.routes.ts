import { Router } from 'express';
import { artisanController } from './artisan.controller.js';
import { validate } from '../../core/middlewares/validate.js';
import { artisanQuerySchema, updateArtisanProfileSchema } from './artisan.schema.js';
import { authenticate, requireRole } from '../../core/middlewares/auth.js';
import { idParamSchema } from '../../core/utils/validation.js';

const router = Router();

router.get('/', validate({ query: artisanQuerySchema }), artisanController.list);
router.get('/:id', validate({ params: idParamSchema }), artisanController.getById);
router.put(
  '/:id',
  authenticate,
  validate({ params: idParamSchema, body: updateArtisanProfileSchema }),
  artisanController.update
);
router.post(
  '/:id/verify',
  authenticate,
  requireRole(['admin']),
  validate({ params: idParamSchema }),
  artisanController.verify
);

export default router;
