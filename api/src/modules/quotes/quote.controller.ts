import type { Request, Response, NextFunction } from 'express';
import { quoteService } from './quote.service.js';

export class QuoteController {
  public async create(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const quote = await quoteService.create(req.user!.id, req.body);
      res.status(201).json({ data: quote, message: 'Quote submitted successfully' });
    } catch (err) {
      next(err);
    }
  }

  public async listForRequest(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const result = await quoteService.listForRequest(
        String(req.params.requestId),
        req.user!.id,
        req.user!.role,
        req.query as any
      );
      res.status(200).json(result);
    } catch (err) {
      next(err);
    }
  }

  public async accept(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const quote = await quoteService.accept(String(req.params.id), req.user!.id);
      res.status(200).json({ data: quote, message: 'Quote accepted successfully' });
    } catch (err) {
      next(err);
    }
  }
}

export const quoteController = new QuoteController();
