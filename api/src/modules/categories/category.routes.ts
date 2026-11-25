import { Router } from 'express';
import { categoryController } from './category.controller.js';
import { validate } from '../../core/middlewares/validate.js';
import { createCategorySchema } from './category.schema.js';
import { authenticate, requireRole } from '../../core/middlewares/auth.js';

const router = Router();

router.get('/', categoryController.list);
router.get('/:id', categoryController.getById);
router.post('/', authenticate, requireRole(['admin']), validate({ body: createCategorySchema }), categoryController.create);

export default router;
