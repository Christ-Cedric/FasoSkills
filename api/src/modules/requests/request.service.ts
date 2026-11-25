import { ServiceRequest } from './request.model.js';
import { NotFoundError, ForbiddenError } from '../../core/errors/app-error.js';
import { formatPaginatedResult, type PaginatedResult } from '../../core/utils/pagination.js';
import { wsManager } from '../../core/websocket/ws-server.js';
import type { CreateRequestInput, UpdateRequestInput, RequestQuery } from './request.schema.js';

export class ServiceRequestService {
  public async list(query: RequestQuery, currentUserId?: string, userRole?: string): Promise<PaginatedResult<any>> {
    const { page, limit, search, city, categoryId, status, myOnly } = query;
    const filter: Record<string, any> = {};

    if (myOnly === 'true' && currentUserId) {
      filter.clientId = currentUserId;
    }
    if (city) filter.city = new RegExp(city, 'i');
    if (categoryId) filter.categoryId = categoryId;
    if (status) filter.status = status;
    if (search) {
      filter.$or = [
        { title: new RegExp(search, 'i') },
        { description: new RegExp(search, 'i') },
      ];
    }

    const skip = (page - 1) * limit;

    const [requests, total] = await Promise.all([
      ServiceRequest.find(filter)
        .populate('clientId', 'fullName email phone profilePicture')
        .populate('categoryId', 'name slug icon')
        .sort({ createdAt: -1 })
        .skip(skip)
        .limit(limit)
        .lean(),
      ServiceRequest.countDocuments(filter),
    ]);

    return formatPaginatedResult(requests, total, page, limit);
  }

  public async getById(id: string) {
    const request = await ServiceRequest.findById(id)
      .populate('clientId', 'fullName email phone profilePicture')
      .populate('categoryId', 'name slug icon');
    if (!request) throw new NotFoundError('Service request');
    return request;
  }

  public async create(clientId: string, data: CreateRequestInput) {
    const request = await ServiceRequest.create({
      clientId,
      categoryId: data.categoryId,
      title: data.title,
      description: data.description,
      city: data.city,
      address: data.address || '',
      photos: data.photos || [],
      status: 'pending',
    });

    const populated = await request.populate([
      { path: 'clientId', select: 'fullName email phone' },
      { path: 'categoryId', select: 'name slug icon' },
    ]);

    // WebSocket real-time broadcast to room / all interested artisans
    wsManager.broadcastAll('request:created', populated);

    return populated;
  }

  public async update(requestId: string, userId: string, userRole: string, data: UpdateRequestInput) {
    const request = await ServiceRequest.findById(requestId);
    if (!request) throw new NotFoundError('Service request');

    // Object-level authorization (A7)
    if (request.clientId.toString() !== userId && userRole !== 'admin') {
      throw new ForbiddenError('You can only update your own service requests');
    }

    if (data.title !== undefined) request.title = data.title;
    if (data.description !== undefined) request.description = data.description;
    if (data.city !== undefined) request.city = data.city;
    if (data.address !== undefined) request.address = data.address;
    if (data.status !== undefined) request.status = data.status;

    await request.save();

    const updated = await request.populate([
      { path: 'clientId', select: 'fullName email phone' },
      { path: 'categoryId', select: 'name slug icon' },
    ]);

    // Notify requester and artisans in real-time via WebSocket
    wsManager.broadcastToRoom(`request:${requestId}`, 'request:updated', updated);
    wsManager.broadcastToUser(request.clientId.toString(), 'request:updated', updated);

    return updated;
  }

  public async cancel(requestId: string, userId: string, userRole: string) {
    return this.update(requestId, userId, userRole, { status: 'cancelled' });
  }
}

export const serviceRequestService = new ServiceRequestService();
