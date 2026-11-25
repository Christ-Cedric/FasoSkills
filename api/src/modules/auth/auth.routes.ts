import { Router } from 'express';
import { authController } from './auth.controller.js';
import { validate } from '../../core/middlewares/validate.js';
import { registerSchema, loginSchema, refreshSchema } from './auth.schema.js';
import { authenticate } from '../../core/middlewares/auth.js';

const router = Router();

router.post('/register', validate({ body: registerSchema }), authController.register);
router.post('/login', validate({ body: loginSchema }), authController.login);
router.post('/refresh', validate({ body: refreshSchema }), authController.refresh);
router.post('/logout', validate({ body: refreshSchema }), authController.logout);
router.get('/me', authenticate, authController.me);

export default router;
