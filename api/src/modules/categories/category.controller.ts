import type { Request, Response, NextFunction } from 'express';
import { categoryService } from './category.service.js';

export class CategoryController {
  public async list(_req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const categories = await categoryService.list();
      res.status(200).json({ data: categories });
    } catch (err) {
      next(err);
    }
  }

  public async getById(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const category = await categoryService.getById(String(req.params.id));
      res.status(200).json({ data: category });
    } catch (err) {
      next(err);
    }
  }

  public async create(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const category = await categoryService.create(req.body);
      res.status(201).json({ data: category, message: 'Category created' });
    } catch (err) {
      next(err);
    }
  }
}

export const categoryController = new CategoryController();
