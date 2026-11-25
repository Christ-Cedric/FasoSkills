import { Quote } from './quote.model.js';
import { ServiceRequest } from '../requests/request.model.js';
import { ArtisanProfile } from '../artisans/artisan.model.js';
import { NotFoundError, ForbiddenError, ConflictError, ValidationError } from '../../core/errors/app-error.js';
import { formatPaginatedResult, type PaginatedResult } from '../../core/utils/pagination.js';
import { wsManager } from '../../core/websocket/ws-server.js';
import type { CreateQuoteInput, QuoteQuery } from './quote.schema.js';

export class QuoteService {
  public async create(userId: string, data: CreateQuoteInput) {
    const artisan = await ArtisanProfile.findOne({ userId });
    if (!artisan) {
      throw new ForbiddenError('Only registered artisans can propose quotes');
    }

    const request = await ServiceRequest.findById(data.requestId);
    if (!request) throw new NotFoundError('Service request');
    if (request.status !== 'pending') {
      throw new ConflictError('Cannot submit a quote to a closed or ongoing request');
    }

    const existingQuote = await Quote.findOne({ requestId: request._id, artisanId: artisan._id });
    if (existingQuote) {
      throw new ConflictError('You have already submitted a quote for this request');
    }

    const quote = await Quote.create({
      requestId: request._id,
      artisanId: artisan._id,
      amount: data.amount,
      estimatedDays: data.estimatedDays,
      message: data.message || '',
      status: 'pending',
    });

    const populated = await quote.populate([
      {
        path: 'artisanId',
        populate: [
          { path: 'userId', select: 'fullName email phone profilePicture isVerified' },
          { path: 'category', select: 'name' },
        ],
      },
    ]);

    // WebSocket real-time notification to client
    wsManager.broadcastToUser(request.clientId.toString(), 'quote:received', {
      requestId: request._id,
      quote: populated,
    });
    wsManager.broadcastToRoom(`request:${request._id}`, 'quote:received', populated);

    return populated;
  }

  public async listForRequest(requestId: string, userId: string, userRole: string, query: QuoteQuery): Promise<PaginatedResult<any>> {
    const request = await ServiceRequest.findById(requestId);
    if (!request) throw new NotFoundError('Service request');

    // Rule: Only the requester (or artisan author, or admin) sees quotes for this request
    const isOwner = request.clientId.toString() === userId;
    const isAdmin = userRole === 'admin';

    let filter: Record<string, any> = { requestId };

    if (!isOwner && !isAdmin) {
      // If user is an artisan, they can only see their own quote for this request
      const artisan = await ArtisanProfile.findOne({ userId });
      if (!artisan) throw new ForbiddenError('Unauthorized to view quotes for this request');
      filter.artisanId = artisan._id;
    }

    const page = query.page || 1;
    const limit = query.limit || 10;
    const skip = (page - 1) * limit;

    const [quotes, total] = await Promise.all([
      Quote.find(filter)
        .populate({
          path: 'artisanId',
          populate: [
            { path: 'userId', select: 'fullName email phone profilePicture isVerified' },
            { path: 'category', select: 'name' },
          ],
        })
        .sort({ amount: 1 })
        .skip(skip)
        .limit(limit)
        .lean(),
      Quote.countDocuments(filter),
    ]);

    return formatPaginatedResult(quotes, total, page, limit);
  }

  public async accept(quoteId: string, userId: string) {
    const quote = await Quote.findById(quoteId).populate('artisanId');
    if (!quote) throw new NotFoundError('Quote');

    const request = await ServiceRequest.findById(quote.requestId);
    if (!request) throw new NotFoundError('Service request');

    // Object-level authorization: Only the client who created the request can accept a quote
    if (request.clientId.toString() !== userId) {
      throw new ForbiddenError('Only the request owner can accept a quote');
    }

    // Rule: One accepted quote per request
    if (request.status !== 'pending') {
      throw new ConflictError('A quote has already been accepted or the request is no longer pending');
    }

    // Accept this quote, reject other quotes for this request
    quote.status = 'accepted';
    await quote.save();

    await Quote.updateMany(
      { requestId: request._id, _id: { $ne: quote._id } },
      { status: 'rejected' }
    );

    request.status = 'in_progress';
    request.acceptedQuoteId = quote._id as any;
    await request.save();

    const artisan: any = quote.artisanId;
    if (artisan && artisan.userId) {
      // WebSocket notification to the artisan that quote was accepted!
      wsManager.broadcastToUser(artisan.userId.toString(), 'quote:accepted', {
        requestId: request._id,
        quoteId: quote._id,
      });
    }
    wsManager.broadcastToRoom(`request:${request._id}`, 'request:in_progress', {
      requestId: request._id,
      acceptedQuoteId: quote._id,
    });

    return quote;
  }
}

export const quoteService = new QuoteService();
