import { Router } from 'express';
import { artisanController } from './artisan.controller.js';
import { validate } from '../../core/middlewares/validate.js';
import { artisanQuerySchema, updateArtisanProfileSchema } from './artisan.schema.js';
import { authenticate, requireRole } from '../../core/middlewares/auth.js';

const router = Router();

router.get('/', validate({ query: artisanQuerySchema }), artisanController.list);
router.get('/:id', artisanController.getById);
router.put('/:id', authenticate, validate({ body: updateArtisanProfileSchema }), artisanController.update);
router.post('/:id/verify', authenticate, requireRole(['admin']), artisanController.verify);

export default router;
